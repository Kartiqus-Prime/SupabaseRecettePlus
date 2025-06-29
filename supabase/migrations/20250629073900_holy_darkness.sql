/*
  # Système de tracking de livraison et gestion des rôles

  1. Nouvelles tables
    - `delivery_personnel` - Personnel de livraison
    - `order_tracking` - Suivi des commandes
    - `delivery_locations` - Positions GPS des livreurs
    - `order_status_history` - Historique des statuts de commande
    - `qr_codes` - Codes QR pour les commandes

  2. Mise à jour des tables existantes
    - `orders` - Ajout de champs pour le tracking
    - `admin_permissions` - Correction et ajout de nouveaux rôles

  3. Fonctions et triggers
    - Fonctions de gestion des statuts
    - Triggers pour les notifications
    - Fonctions de géolocalisation

  4. Sécurité
    - RLS pour toutes les nouvelles tables
    - Politiques de sécurité par rôle
*/

-- Extension pour la géolocalisation
CREATE EXTENSION IF NOT EXISTS postgis;

-- Enum pour les rôles utilisateur
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM (
        'user',
        'super_admin',
        'manager',
        'marketing_manager',
        'content_creator',
        'admin_assistant',
        'order_validator',
        'delivery_personnel'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Enum pour les statuts de commande
DO $$ BEGIN
    CREATE TYPE order_status AS ENUM (
        'pending',
        'confirmed',
        'preparing',
        'ready_for_pickup',
        'picked_up',
        'in_transit',
        'delivered',
        'cancelled',
        'returned'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Enum pour les statuts de livraison
DO $$ BEGIN
    CREATE TYPE delivery_status AS ENUM (
        'available',
        'busy',
        'offline',
        'on_break'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Table pour le personnel de livraison
CREATE TABLE IF NOT EXISTS delivery_personnel (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    employee_id text UNIQUE NOT NULL,
    full_name text NOT NULL,
    phone_number text NOT NULL,
    vehicle_type text NOT NULL DEFAULT 'motorcycle',
    license_plate text,
    status delivery_status DEFAULT 'offline',
    current_location geography(POINT, 4326),
    last_location_update timestamptz DEFAULT now(),
    is_active boolean DEFAULT true,
    rating numeric(2,1) DEFAULT 5.0,
    total_deliveries integer DEFAULT 0,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Mise à jour de la table orders
DO $$
BEGIN
    -- Ajouter les colonnes si elles n'existent pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'status') THEN
        ALTER TABLE orders ADD COLUMN status order_status DEFAULT 'pending';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'delivery_address') THEN
        ALTER TABLE orders ADD COLUMN delivery_address jsonb;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'delivery_notes') THEN
        ALTER TABLE orders ADD COLUMN delivery_notes text;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'delivery_fee') THEN
        ALTER TABLE orders ADD COLUMN delivery_fee numeric(10,2) DEFAULT 2000.0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'estimated_delivery_time') THEN
        ALTER TABLE orders ADD COLUMN estimated_delivery_time timestamptz;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'delivery_personnel_id') THEN
        ALTER TABLE orders ADD COLUMN delivery_personnel_id uuid REFERENCES delivery_personnel(id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'qr_code') THEN
        ALTER TABLE orders ADD COLUMN qr_code text UNIQUE;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'updated_at') THEN
        ALTER TABLE orders ADD COLUMN updated_at timestamptz DEFAULT now();
    END IF;
END $$;

-- Table pour les codes QR des commandes
CREATE TABLE IF NOT EXISTS qr_codes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
    qr_code text UNIQUE NOT NULL,
    is_used boolean DEFAULT false,
    used_by uuid REFERENCES delivery_personnel(id),
    used_at timestamptz,
    expires_at timestamptz NOT NULL,
    created_at timestamptz DEFAULT now()
);

-- Table pour le suivi des commandes
CREATE TABLE IF NOT EXISTS order_tracking (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
    delivery_personnel_id uuid REFERENCES delivery_personnel(id),
    current_location geography(POINT, 4326),
    estimated_arrival timestamptz,
    distance_remaining numeric(10,2), -- en kilomètres
    notes text,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Table pour l'historique des statuts de commande
CREATE TABLE IF NOT EXISTS order_status_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id uuid REFERENCES orders(id) ON DELETE CASCADE,
    old_status order_status,
    new_status order_status NOT NULL,
    changed_by uuid REFERENCES auth.users(id),
    changed_by_role user_role,
    notes text,
    location geography(POINT, 4326),
    created_at timestamptz DEFAULT now()
);

-- Table pour les positions GPS des livreurs
CREATE TABLE IF NOT EXISTS delivery_locations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    delivery_personnel_id uuid REFERENCES delivery_personnel(id) ON DELETE CASCADE,
    order_id uuid REFERENCES orders(id),
    location geography(POINT, 4326) NOT NULL,
    speed numeric(5,2), -- km/h
    heading numeric(5,2), -- degrés
    accuracy numeric(10,2), -- mètres
    created_at timestamptz DEFAULT now()
);

-- Correction de la table admin_permissions
DO $$
BEGIN
    -- Supprimer les contraintes existantes si elles existent
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'admin_permissions_user_id_key') THEN
        ALTER TABLE admin_permissions DROP CONSTRAINT admin_permissions_user_id_key;
    END IF;
    
    -- Ajouter les nouvelles colonnes si elles n'existent pas
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'admin_permissions' AND column_name = 'role') THEN
        ALTER TABLE admin_permissions ADD COLUMN role user_role DEFAULT 'user';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'admin_permissions' AND column_name = 'can_manage_orders') THEN
        ALTER TABLE admin_permissions ADD COLUMN can_manage_orders boolean DEFAULT false;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'admin_permissions' AND column_name = 'can_manage_delivery') THEN
        ALTER TABLE admin_permissions ADD COLUMN can_manage_delivery boolean DEFAULT false;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'admin_permissions' AND column_name = 'can_validate_orders') THEN
        ALTER TABLE admin_permissions ADD COLUMN can_validate_orders boolean DEFAULT false;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'admin_permissions' AND column_name = 'can_track_delivery') THEN
        ALTER TABLE admin_permissions ADD COLUMN can_track_delivery boolean DEFAULT false;
    END IF;
END $$;

-- Supprimer les données existantes avec user_id null
DELETE FROM admin_permissions WHERE user_id IS NULL;

-- Recréer la contrainte unique
ALTER TABLE admin_permissions ADD CONSTRAINT admin_permissions_user_id_key UNIQUE (user_id);

-- Fonction pour générer un code QR unique
CREATE OR REPLACE FUNCTION generate_qr_code()
RETURNS text AS $$
BEGIN
    RETURN 'QR_' || upper(substring(gen_random_uuid()::text from 1 for 8)) || '_' || extract(epoch from now())::bigint;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour créer un code QR pour une commande
CREATE OR REPLACE FUNCTION create_order_qr_code(order_uuid uuid)
RETURNS text AS $$
DECLARE
    qr_code_value text;
BEGIN
    qr_code_value := generate_qr_code();
    
    INSERT INTO qr_codes (order_id, qr_code, expires_at)
    VALUES (order_uuid, qr_code_value, now() + interval '24 hours');
    
    UPDATE orders SET qr_code = qr_code_value WHERE id = order_uuid;
    
    RETURN qr_code_value;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour scanner un code QR
CREATE OR REPLACE FUNCTION scan_qr_code(qr_code_value text, personnel_uuid uuid)
RETURNS jsonb AS $$
DECLARE
    qr_record record;
    order_record record;
    result jsonb;
BEGIN
    -- Vérifier le code QR
    SELECT * INTO qr_record FROM qr_codes 
    WHERE qr_code = qr_code_value AND NOT is_used AND expires_at > now();
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('success', false, 'message', 'Code QR invalide ou expiré');
    END IF;
    
    -- Récupérer la commande
    SELECT * INTO order_record FROM orders WHERE id = qr_record.order_id;
    
    IF order_record.status NOT IN ('confirmed', 'preparing', 'ready_for_pickup') THEN
        RETURN jsonb_build_object('success', false, 'message', 'Commande non disponible pour la livraison');
    END IF;
    
    -- Marquer le code QR comme utilisé
    UPDATE qr_codes SET 
        is_used = true,
        used_by = personnel_uuid,
        used_at = now()
    WHERE id = qr_record.id;
    
    -- Assigner la commande au livreur
    UPDATE orders SET 
        delivery_personnel_id = personnel_uuid,
        status = 'picked_up',
        updated_at = now()
    WHERE id = qr_record.order_id;
    
    -- Ajouter à l'historique
    INSERT INTO order_status_history (order_id, old_status, new_status, changed_by, changed_by_role, notes)
    VALUES (qr_record.order_id, order_record.status, 'picked_up', 
            (SELECT user_id FROM delivery_personnel WHERE id = personnel_uuid),
            'delivery_personnel', 'Commande prise en charge par le livreur');
    
    -- Mettre à jour le statut du livreur
    UPDATE delivery_personnel SET status = 'busy' WHERE id = personnel_uuid;
    
    RETURN jsonb_build_object(
        'success', true, 
        'message', 'Commande assignée avec succès',
        'order_id', qr_record.order_id,
        'order_details', row_to_json(order_record)
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour mettre à jour la position du livreur
CREATE OR REPLACE FUNCTION update_delivery_location(
    personnel_uuid uuid,
    order_uuid uuid,
    latitude numeric,
    longitude numeric,
    speed_val numeric DEFAULT NULL,
    heading_val numeric DEFAULT NULL,
    accuracy_val numeric DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
    location_point geography;
BEGIN
    location_point := ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography;
    
    -- Insérer la nouvelle position
    INSERT INTO delivery_locations (
        delivery_personnel_id, order_id, location, speed, heading, accuracy
    ) VALUES (
        personnel_uuid, order_uuid, location_point, speed_val, heading_val, accuracy_val
    );
    
    -- Mettre à jour la position actuelle du livreur
    UPDATE delivery_personnel SET 
        current_location = location_point,
        last_location_update = now()
    WHERE id = personnel_uuid;
    
    -- Mettre à jour le tracking de la commande
    INSERT INTO order_tracking (order_id, delivery_personnel_id, current_location, updated_at)
    VALUES (order_uuid, personnel_uuid, location_point, now())
    ON CONFLICT (order_id) DO UPDATE SET
        current_location = location_point,
        delivery_personnel_id = personnel_uuid,
        updated_at = now();
    
    RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour changer le statut d'une commande
CREATE OR REPLACE FUNCTION update_order_status(
    order_uuid uuid,
    new_status_val order_status,
    user_uuid uuid,
    user_role_val user_role,
    notes_val text DEFAULT NULL,
    latitude numeric DEFAULT NULL,
    longitude numeric DEFAULT NULL
)
RETURNS boolean AS $$
DECLARE
    old_status_val order_status;
    location_point geography;
BEGIN
    -- Récupérer l'ancien statut
    SELECT status INTO old_status_val FROM orders WHERE id = order_uuid;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Commande non trouvée';
    END IF;
    
    -- Créer le point géographique si les coordonnées sont fournies
    IF latitude IS NOT NULL AND longitude IS NOT NULL THEN
        location_point := ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography;
    END IF;
    
    -- Mettre à jour le statut de la commande
    UPDATE orders SET 
        status = new_status_val,
        updated_at = now()
    WHERE id = order_uuid;
    
    -- Ajouter à l'historique
    INSERT INTO order_status_history (
        order_id, old_status, new_status, changed_by, changed_by_role, notes, location
    ) VALUES (
        order_uuid, old_status_val, new_status_val, user_uuid, user_role_val, notes_val, location_point
    );
    
    -- Si la commande est livrée, libérer le livreur
    IF new_status_val = 'delivered' THEN
        UPDATE delivery_personnel SET 
            status = 'available',
            total_deliveries = total_deliveries + 1
        WHERE id = (SELECT delivery_personnel_id FROM orders WHERE id = order_uuid);
    END IF;
    
    RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Fonction pour calculer la distance entre deux points
CREATE OR REPLACE FUNCTION calculate_distance(
    lat1 numeric, lon1 numeric,
    lat2 numeric, lon2 numeric
)
RETURNS numeric AS $$
DECLARE
    point1 geography;
    point2 geography;
    distance_meters numeric;
BEGIN
    point1 := ST_SetSRID(ST_MakePoint(lon1, lat1), 4326)::geography;
    point2 := ST_SetSRID(ST_MakePoint(lon2, lat2), 4326)::geography;
    
    distance_meters := ST_Distance(point1, point2);
    
    -- Retourner la distance en kilomètres
    RETURN distance_meters / 1000.0;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour obtenir les commandes disponibles pour un livreur
CREATE OR REPLACE FUNCTION get_available_orders_for_delivery(personnel_uuid uuid)
RETURNS TABLE (
    order_id uuid,
    total_amount numeric,
    delivery_address jsonb,
    delivery_notes text,
    estimated_delivery_time timestamptz,
    qr_code text,
    distance_km numeric,
    created_at timestamptz
) AS $$
DECLARE
    personnel_location geography;
BEGIN
    -- Récupérer la position actuelle du livreur
    SELECT current_location INTO personnel_location 
    FROM delivery_personnel 
    WHERE id = personnel_uuid;
    
    RETURN QUERY
    SELECT 
        o.id,
        o.total_amount,
        o.delivery_address,
        o.delivery_notes,
        o.estimated_delivery_time,
        o.qr_code,
        CASE 
            WHEN personnel_location IS NOT NULL AND o.delivery_address->>'latitude' IS NOT NULL 
            THEN ST_Distance(
                personnel_location,
                ST_SetSRID(ST_MakePoint(
                    (o.delivery_address->>'longitude')::numeric,
                    (o.delivery_address->>'latitude')::numeric
                ), 4326)::geography
            ) / 1000.0
            ELSE NULL
        END as distance_km,
        o.created_at
    FROM orders o
    WHERE o.status IN ('confirmed', 'preparing', 'ready_for_pickup')
    AND o.delivery_personnel_id IS NULL
    ORDER BY 
        CASE WHEN distance_km IS NOT NULL THEN distance_km END ASC,
        o.created_at ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger pour créer automatiquement un code QR lors de la confirmation d'une commande
CREATE OR REPLACE FUNCTION create_qr_on_order_confirm()
RETURNS trigger AS $$
BEGIN
    IF NEW.status = 'confirmed' AND (OLD.status IS NULL OR OLD.status != 'confirmed') THEN
        NEW.qr_code := generate_qr_code();
        
        INSERT INTO qr_codes (order_id, qr_code, expires_at)
        VALUES (NEW.id, NEW.qr_code, now() + interval '24 hours');
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le trigger
DROP TRIGGER IF EXISTS trigger_create_qr_on_order_confirm ON orders;
CREATE TRIGGER trigger_create_qr_on_order_confirm
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION create_qr_on_order_confirm();

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Appliquer le trigger aux tables nécessaires
DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_delivery_personnel_updated_at ON delivery_personnel;
CREATE TRIGGER update_delivery_personnel_updated_at
    BEFORE UPDATE ON delivery_personnel
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_order_tracking_updated_at ON order_tracking;
CREATE TRIGGER update_order_tracking_updated_at
    BEFORE UPDATE ON order_tracking
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Activer RLS sur toutes les nouvelles tables
ALTER TABLE delivery_personnel ENABLE ROW LEVEL SECURITY;
ALTER TABLE qr_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE delivery_locations ENABLE ROW LEVEL SECURITY;

-- Politiques RLS pour delivery_personnel
CREATE POLICY "Super admins can manage all delivery personnel"
    ON delivery_personnel FOR ALL
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM admin_permissions ap
            WHERE ap.user_id = auth.uid() 
            AND (ap.is_super_admin = true OR ap.can_manage_delivery = true)
        )
    );

CREATE POLICY "Delivery personnel can view and update their own data"
    ON delivery_personnel FOR ALL
    TO public
    USING (user_id = auth.uid());

CREATE POLICY "Users can view delivery personnel for their orders"
    ON delivery_personnel FOR SELECT
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM orders o
            WHERE o.user_id = auth.uid() 
            AND o.delivery_personnel_id = delivery_personnel.id
        )
    );

-- Politiques RLS pour orders (mise à jour)
DROP POLICY IF EXISTS "Users can view own orders" ON orders;
CREATE POLICY "Users can view own orders"
    ON orders FOR SELECT
    TO public
    USING (user_id = auth.uid());

CREATE POLICY "Admins can manage all orders"
    ON orders FOR ALL
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM admin_permissions ap
            WHERE ap.user_id = auth.uid() 
            AND (ap.is_super_admin = true OR ap.can_manage_orders = true OR ap.can_validate_orders = true)
        )
    );

CREATE POLICY "Delivery personnel can view assigned orders"
    ON orders FOR SELECT
    TO public
    USING (
        delivery_personnel_id IN (
            SELECT id FROM delivery_personnel WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Delivery personnel can update assigned orders"
    ON orders FOR UPDATE
    TO public
    USING (
        delivery_personnel_id IN (
            SELECT id FROM delivery_personnel WHERE user_id = auth.uid()
        )
    );

-- Politiques RLS pour qr_codes
CREATE POLICY "Admins can manage QR codes"
    ON qr_codes FOR ALL
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM admin_permissions ap
            WHERE ap.user_id = auth.uid() 
            AND (ap.is_super_admin = true OR ap.can_manage_orders = true)
        )
    );

CREATE POLICY "Delivery personnel can scan QR codes"
    ON qr_codes FOR SELECT
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM delivery_personnel dp
            WHERE dp.user_id = auth.uid()
        )
    );

-- Politiques RLS pour order_tracking
CREATE POLICY "Users can view tracking for their orders"
    ON order_tracking FOR SELECT
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM orders o
            WHERE o.id = order_tracking.order_id 
            AND o.user_id = auth.uid()
        )
    );

CREATE POLICY "Delivery personnel can manage tracking for assigned orders"
    ON order_tracking FOR ALL
    TO public
    USING (
        delivery_personnel_id IN (
            SELECT id FROM delivery_personnel WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all tracking"
    ON order_tracking FOR SELECT
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM admin_permissions ap
            WHERE ap.user_id = auth.uid() 
            AND (ap.is_super_admin = true OR ap.can_manage_orders = true OR ap.can_track_delivery = true)
        )
    );

-- Politiques RLS pour order_status_history
CREATE POLICY "Users can view status history for their orders"
    ON order_status_history FOR SELECT
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM orders o
            WHERE o.id = order_status_history.order_id 
            AND o.user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all status history"
    ON order_status_history FOR SELECT
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM admin_permissions ap
            WHERE ap.user_id = auth.uid() 
            AND (ap.is_super_admin = true OR ap.can_manage_orders = true)
        )
    );

-- Politiques RLS pour delivery_locations
CREATE POLICY "Users can view delivery locations for their orders"
    ON delivery_locations FOR SELECT
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM orders o
            WHERE o.id = delivery_locations.order_id 
            AND o.user_id = auth.uid()
        )
    );

CREATE POLICY "Delivery personnel can manage their own locations"
    ON delivery_locations FOR ALL
    TO public
    USING (
        delivery_personnel_id IN (
            SELECT id FROM delivery_personnel WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Admins can view all delivery locations"
    ON delivery_locations FOR SELECT
    TO public
    USING (
        EXISTS (
            SELECT 1 FROM admin_permissions ap
            WHERE ap.user_id = auth.uid() 
            AND (ap.is_super_admin = true OR ap.can_track_delivery = true)
        )
    );

-- Index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_delivery_personnel_user_id ON delivery_personnel(user_id);
CREATE INDEX IF NOT EXISTS idx_delivery_personnel_status ON delivery_personnel(status);
CREATE INDEX IF NOT EXISTS idx_delivery_personnel_location ON delivery_personnel USING GIST(current_location);

CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_delivery_personnel ON orders(delivery_personnel_id);
CREATE INDEX IF NOT EXISTS idx_orders_qr_code ON orders(qr_code);

CREATE INDEX IF NOT EXISTS idx_qr_codes_code ON qr_codes(qr_code);
CREATE INDEX IF NOT EXISTS idx_qr_codes_order_id ON qr_codes(order_id);
CREATE INDEX IF NOT EXISTS idx_qr_codes_expires_at ON qr_codes(expires_at);

CREATE INDEX IF NOT EXISTS idx_order_tracking_order_id ON order_tracking(order_id);
CREATE INDEX IF NOT EXISTS idx_order_tracking_personnel ON order_tracking(delivery_personnel_id);
CREATE INDEX IF NOT EXISTS idx_order_tracking_location ON order_tracking USING GIST(current_location);

CREATE INDEX IF NOT EXISTS idx_order_status_history_order_id ON order_status_history(order_id);
CREATE INDEX IF NOT EXISTS idx_order_status_history_created_at ON order_status_history(created_at);

CREATE INDEX IF NOT EXISTS idx_delivery_locations_personnel ON delivery_locations(delivery_personnel_id);
CREATE INDEX IF NOT EXISTS idx_delivery_locations_order ON delivery_locations(order_id);
CREATE INDEX IF NOT EXISTS idx_delivery_locations_created_at ON delivery_locations(created_at);
CREATE INDEX IF NOT EXISTS idx_delivery_locations_location ON delivery_locations USING GIST(location);

-- Données d'exemple pour les rôles
INSERT INTO admin_permissions (user_id, role, is_super_admin, can_manage_users, can_manage_products, can_manage_recipes, can_manage_videos, can_manage_categories, can_manage_orders, can_manage_delivery, can_validate_orders, can_track_delivery)
VALUES 
-- Super Admin (tous les droits)
('00000000-0000-0000-0000-000000000001', 'super_admin', true, true, true, true, true, true, true, true, true, true),
-- Gérant (presque tous les droits)
('00000000-0000-0000-0000-000000000002', 'manager', false, true, true, true, true, true, true, true, true, true),
-- Responsable Marketing (produits, recettes, newsletters)
('00000000-0000-0000-0000-000000000003', 'marketing_manager', false, false, true, true, false, true, false, false, false, false),
-- Créateur de contenu (vidéos, recettes, produits en lecture/écriture)
('00000000-0000-0000-0000-000000000004', 'content_creator', false, false, true, true, true, false, false, false, false, false),
-- Assistant administratif (moins de droits que le gérant)
('00000000-0000-0000-0000-000000000005', 'admin_assistant', false, false, true, true, false, true, true, false, true, true),
-- Validateur de commandes
('00000000-0000-0000-0000-000000000006', 'order_validator', false, false, false, false, false, false, true, false, true, true)
ON CONFLICT (user_id) DO NOTHING;