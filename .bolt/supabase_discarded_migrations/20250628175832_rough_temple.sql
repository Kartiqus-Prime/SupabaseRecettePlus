/*
  # Data Seeding Complet - Basé sur la structure db.json

  1. Suppression de toutes les données existantes
  2. Insertion des données avec relations correctes
  3. Respect de la structure exacte de la base de données
  4. Utilisation de double apostrophe pour l''échappement
*/

-- ==================== SUPPRESSION DES DONNÉES EXISTANTES ====================
-- Dans l''ordre des dépendances pour éviter les erreurs de contraintes

DELETE FROM user_preconfigured_carts;
DELETE FROM recipe_cart_items;
DELETE FROM recipe_user_carts;
DELETE FROM personal_cart_items;
DELETE FROM personal_carts;
DELETE FROM user_cart_items;
DELETE FROM user_carts;
DELETE FROM preconfigured_carts;
DELETE FROM user_history;
DELETE FROM favorites;
DELETE FROM videos;
DELETE FROM products;
DELETE FROM recipes;
DELETE FROM admin_permissions;
DELETE FROM profiles;

-- ==================== PROFILS UTILISATEURS ====================

INSERT INTO profiles (id, display_name, email, phone_number, role, created_at, updated_at) VALUES
-- Utilisateur admin
('550e8400-e29b-41d4-a716-446655440000', 'Admin Recette+', 'admin@recetteplus.com', '+33123456789', 'admin', NOW(), NOW()),
-- Utilisateurs normaux
('550e8400-e29b-41d4-a716-446655440001', 'Marie Dubois', 'marie.dubois@email.com', '+33123456790', 'user', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'Pierre Martin', 'pierre.martin@email.com', '+33123456791', 'user', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440003', 'Sophie Laurent', 'sophie.laurent@email.com', '+33123456792', 'user', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440004', 'Thomas Bernard', 'thomas.bernard@email.com', NULL, 'user', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440005', 'Julie Moreau', 'julie.moreau@email.com', '+33123456793', 'user', NOW(), NOW());

-- ==================== PERMISSIONS ADMIN ====================

INSERT INTO admin_permissions (user_id, is_super_admin, can_manage_users, can_manage_content, can_view_analytics, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', true, true, true, true, NOW());

-- ==================== RECETTES ====================

INSERT INTO recipes (id, title, description, category, cook_time, prep_time, servings, difficulty, rating, image_url, ingredients, instructions, created_by, is_active, created_at, updated_at) VALUES
-- Plats principaux
('recipe-001', 'Pasta Carbonara Authentique', 'Un classique italien crémeux et délicieux avec seulement 5 ingrédients. La vraie recette romaine sans crème fraîche !', 'Plats principaux', 20, 10, 4, 'Facile', 4.8, 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg', 
 '["400g de spaghetti", "200g de pancetta ou guanciale", "4 œufs entiers", "100g de parmesan râpé", "Poivre noir fraîchement moulu", "Sel"]',
 '["Faire cuire les pâtes dans une grande casserole d''eau salée", "Faire revenir la pancetta dans une poêle jusqu''à ce qu''elle soit croustillante", "Battre les œufs avec le parmesan et le poivre dans un bol", "Égoutter les pâtes en réservant un peu d''eau de cuisson", "Mélanger rapidement les pâtes chaudes avec le mélange œuf-fromage", "Ajouter la pancetta et un peu d''eau de cuisson si nécessaire", "Servir immédiatement avec du parmesan supplémentaire"]',
 '550e8400-e29b-41d4-a716-446655440001', true, NOW() - INTERVAL '2 days', NOW()),

('recipe-002', 'Ratatouille Traditionnelle', 'La recette authentique de la ratatouille provençale, un plat végétarien coloré et savoureux qui sent bon le soleil', 'Plats principaux', 45, 20, 6, 'Moyen', 4.6, 'https://images.pexels.com/photos/8629141/pexels-photo-8629141.jpeg',
 '["2 aubergines moyennes", "3 courgettes", "2 poivrons rouges", "4 tomates bien mûres", "1 gros oignon", "4 gousses d''ail", "Herbes de Provence", "Huile d''olive extra vierge", "Sel et poivre du moulin"]',
 '["Couper tous les légumes en dés réguliers de 2cm", "Faire revenir l''oignon et l''ail dans l''huile d''olive", "Ajouter les aubergines et faire cuire 10 minutes", "Incorporer les courgettes et poivrons", "Ajouter les tomates et les herbes de Provence", "Laisser mijoter 30 minutes à feu doux en remuant de temps en temps", "Rectifier l''assaisonnement et servir chaud ou tiède"]',
 '550e8400-e29b-41d4-a716-446655440002', true, NOW() - INTERVAL '1 day', NOW()),

('recipe-003', 'Bœuf Bourguignon Traditionnel', 'Le grand classique de la cuisine française, mijoté avec amour pendant des heures', 'Plats principaux', 180, 30, 6, 'Difficile', 4.9, 'https://images.pexels.com/photos/6107787/pexels-photo-6107787.jpeg',
 '["1.5kg de bœuf à braiser", "200g de lardons", "500ml de vin rouge de Bourgogne", "300g de champignons de Paris", "300g de petits oignons", "3 carottes", "2 gousses d''ail", "Bouquet garni", "Beurre", "Farine"]',
 '["Faire mariner la viande dans le vin rouge 24h", "Faire revenir les lardons puis la viande", "Flamber au cognac", "Ajouter la farine et mélanger", "Mouiller avec le vin de marinade", "Ajouter le bouquet garni et laisser mijoter 2h30", "Faire revenir les légumes séparément", "Ajouter les légumes 30 minutes avant la fin", "Servir avec des pommes de terre vapeur"]',
 '550e8400-e29b-41d4-a716-446655440001', true, NOW() - INTERVAL '3 days', NOW()),

-- Entrées
('recipe-004', 'Salade César Parfaite', 'La vraie salade César avec sa sauce crémeuse et ses croûtons croustillants, comme dans les grands restaurants', 'Entrées', 15, 15, 2, 'Facile', 4.5, 'https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg',
 '["2 cœurs de laitue romaine", "100g de parmesan", "4 tranches de pain de mie", "2 gousses d''ail", "2 jaunes d''œuf", "6 filets d''anchois", "Jus de citron", "Huile d''olive", "Moutarde de Dijon", "Sauce Worcestershire"]',
 '["Préparer les croûtons en faisant griller le pain frotté à l''ail", "Laver et couper la salade en morceaux", "Préparer la sauce en mélangeant jaunes d''œuf, anchois, moutarde et citron", "Monter la sauce à l''huile d''olive comme une mayonnaise", "Ajouter la sauce Worcestershire", "Mélanger la salade avec la sauce", "Ajouter les croûtons et le parmesan râpé", "Servir immédiatement"]',
 '550e8400-e29b-41d4-a716-446655440003', true, NOW() - INTERVAL '12 hours', NOW()),

('recipe-005', 'Velouté de Potimarron', 'Un velouté onctueux et réconfortant, parfait pour l''automne et l''hiver', 'Entrées', 35, 15, 4, 'Facile', 4.4, 'https://images.pexels.com/photos/539451/pexels-photo-539451.jpeg',
 '["1 potimarron de 1kg", "1 oignon", "1 pomme de terre", "50cl de bouillon de légumes", "20cl de crème fraîche", "Muscade", "Sel et poivre", "Graines de courge grillées"]',
 '["Éplucher et couper le potimarron en cubes", "Faire revenir l''oignon émincé", "Ajouter le potimarron et la pomme de terre", "Mouiller avec le bouillon", "Laisser cuire 25 minutes", "Mixer finement", "Ajouter la crème et la muscade", "Rectifier l''assaisonnement", "Servir avec les graines grillées"]',
 '550e8400-e29b-41d4-a716-446655440004', true, NOW() - INTERVAL '8 hours', NOW()),

-- Desserts
('recipe-006', 'Tiramisu Express', 'Version rapide du célèbre dessert italien, prêt en 15 minutes mais avec tout le goût authentique', 'Desserts', 15, 15, 6, 'Facile', 4.9, 'https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg',
 '["500g de mascarpone", "6 jaunes d''œuf", "100g de sucre", "300ml de café fort refroidi", "2 paquets de biscuits à la cuillère", "Cacao en poudre amer", "Amaretto (optionnel)", "3 blancs d''œuf"]',
 '["Battre les jaunes d''œuf avec le sucre jusqu''à blanchiment", "Incorporer délicatement le mascarpone", "Monter les blancs en neige et les incorporer", "Tremper rapidement les biscuits dans le café", "Disposer une couche de biscuits dans le plat", "Recouvrir de crème au mascarpone", "Répéter l''opération", "Saupoudrer de cacao et réfrigérer 2h minimum"]',
 '550e8400-e29b-41d4-a716-446655440001', true, NOW() - INTERVAL '6 hours', NOW()),

('recipe-007', 'Tarte Tatin aux Pommes', 'La célèbre tarte renversée aux pommes caramélisées, un dessert emblématique français', 'Desserts', 45, 30, 8, 'Moyen', 4.7, 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
 '["1 pâte brisée", "8 pommes Reinette", "150g de sucre", "50g de beurre", "1 cuillère à soupe de calvados", "Pincée de sel"]',
 '["Éplucher et couper les pommes en quartiers", "Faire un caramel avec le sucre dans un moule", "Disposer les pommes sur le caramel", "Ajouter le beurre et le calvados", "Recouvrir de pâte en rentrant les bords", "Cuire 25 minutes à 200°C", "Laisser tiédir 5 minutes", "Démouler d''un coup sec", "Servir tiède avec de la crème fraîche"]',
 '550e8400-e29b-41d4-a716-446655440002', true, NOW() - INTERVAL '4 hours', NOW()),

-- Boissons
('recipe-008', 'Smoothie Bowl Tropical', 'Un petit-déjeuner coloré et nutritif aux fruits exotiques, parfait pour commencer la journée en beauté', 'Boissons', 5, 10, 1, 'Facile', 4.3, 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg',
 '["1 mangue mûre", "1/2 ananas", "1 banane", "200ml de lait de coco", "1 cuillère de miel", "Granola maison", "Noix de coco râpée", "Fruits rouges", "Graines de chia"]',
 '["Éplucher et couper les fruits en morceaux", "Mixer mangue, ananas et banane avec le lait de coco", "Ajouter le miel et mixer à nouveau", "Verser dans un bol", "Décorer avec granola, coco râpée et fruits rouges", "Parsemer de graines de chia", "Servir immédiatement"]',
 '550e8400-e29b-41d4-a716-446655440004', true, NOW() - INTERVAL '3 hours', NOW()),

-- Végétarien
('recipe-009', 'Buddha Bowl Nutritif', 'Bol complet végétarien avec quinoa et légumes de saison, équilibré et coloré', 'Végétarien', 25, 15, 2, 'Facile', 4.6, 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
 '["150g de quinoa", "1 avocat", "200g de brocolis", "1 betterave cuite", "100g d''épinards frais", "50g de graines de tournesol", "Sauce tahini", "Huile d''olive", "Citron", "Graines de sésame"]',
 '["Cuire le quinoa selon les instructions du paquet", "Faire cuire les brocolis à la vapeur", "Couper l''avocat et la betterave en tranches", "Préparer la sauce tahini avec citron et huile", "Disposer tous les ingrédients harmonieusement dans un bol", "Arroser de sauce et parsemer de graines", "Servir tiède ou froid selon les goûts"]',
 '550e8400-e29b-41d4-a716-446655440002', true, NOW() - INTERVAL '2 hours', NOW()),

-- Rapide
('recipe-010', 'Omelette Express aux Herbes', 'Petit-déjeuner rapide et protéiné en moins de 10 minutes, parfait pour les matins pressés', 'Rapide', 8, 2, 1, 'Facile', 4.2, 'https://images.pexels.com/photos/824635/pexels-photo-824635.jpeg',
 '["3 œufs frais", "20g de beurre", "50g de fromage râpé", "Herbes fraîches (ciboulette, persil)", "Sel et poivre du moulin"]',
 '["Battre les œufs avec sel et poivre", "Chauffer le beurre dans une poêle antiadhésive", "Verser les œufs et laisser prendre", "Ajouter le fromage sur une moitié", "Plier l''omelette en deux", "Parsemer d''herbes fraîches", "Servir immédiatement bien chaud"]',
 '550e8400-e29b-41d4-a716-446655440003', true, NOW() - INTERVAL '1 hour', NOW()),

('recipe-011', 'Croissants Maison', 'Réalisez de vrais croissants français chez vous avec cette recette détaillée de boulanger', 'Boulangerie', 420, 180, 8, 'Difficile', 4.8, 'https://images.pexels.com/photos/2067396/pexels-photo-2067396.jpeg',
 '["500g de farine T55", "10g de sel", "50g de sucre", "10g de levure fraîche", "300ml de lait tiède", "250g de beurre froid", "1 œuf pour dorure"]',
 '["Mélanger farine, sel et sucre dans un saladier", "Diluer la levure dans le lait tiède", "Pétrir la pâte et laisser lever 1h", "Étaler le beurre en rectangle", "Incorporer le beurre par tourage", "Effectuer 3 tours avec repos au frigo", "Détailler et façonner les croissants", "Laisser lever 2h puis cuire 15min à 200°C"]',
 '550e8400-e29b-41d4-a716-446655440001', true, NOW() - INTERVAL '30 minutes', NOW()),

('recipe-012', 'Quiche Lorraine Traditionnelle', 'La vraie quiche lorraine avec sa pâte brisée maison et sa garniture crémeuse', 'Plats principaux', 40, 25, 6, 'Moyen', 4.5, 'https://images.pexels.com/photos/4518843/pexels-photo-4518843.jpeg',
 '["250g de farine", "125g de beurre", "1 œuf", "200g de lardons", "3 œufs", "25cl de crème fraîche", "100ml de lait", "Muscade", "Sel et poivre"]',
 '["Préparer la pâte brisée et la laisser reposer", "Étaler la pâte dans un moule", "Faire revenir les lardons sans matière grasse", "Battre les œufs avec la crème et le lait", "Assaisonner avec muscade, sel et poivre", "Disposer les lardons sur la pâte", "Verser l''appareil à quiche", "Cuire 35 minutes à 180°C"]',
 '550e8400-e29b-41d4-a716-446655440005', true, NOW() - INTERVAL '45 minutes', NOW());

-- ==================== PRODUITS ====================

INSERT INTO products (id, name, description, category, price, rating, image_url, in_stock, unit, created_at, updated_at) VALUES
-- Épices
('prod-001', 'Curcuma Bio en Poudre', 'Curcuma bio de qualité premium, anti-inflammatoire naturel aux mille vertus', 'Épices', 850.0, 4.7, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'pot 100g', NOW(), NOW()),
('prod-002', 'Mélange 5 Épices Chinoises', 'Mélange traditionnel pour cuisine asiatique : anis étoilé, clou de girofle, cannelle, fenouil, poivre', 'Épices', 1200.0, 4.5, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'sachet 50g', NOW(), NOW()),
('prod-003', 'Paprika Fumé de La Vera', 'Paprika espagnol fumé au bois de chêne, saveur intense et authentique', 'Épices', 1450.0, 4.8, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'boîte 75g', NOW(), NOW()),
('prod-004', 'Cannelle de Ceylan Bâtons', 'Vraie cannelle de Ceylan, arôme délicat et sucré, qualité supérieure', 'Épices', 1650.0, 4.6, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'sachet 30g', NOW(), NOW()),
('prod-005', 'Herbes de Provence Bio', 'Mélange traditionnel d''herbes de Provence : thym, romarin, origan, sarriette', 'Épices', 950.0, 4.4, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'sachet 40g', NOW(), NOW()),

-- Huiles
('prod-006', 'Huile d''Olive Extra Vierge', 'Huile d''olive premium de première pression à froid, fruité intense', 'Huiles', 4250.0, 4.8, 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg', true, 'bouteille 500ml', NOW(), NOW()),
('prod-007', 'Huile de Coco Vierge Bio', 'Huile de coco pure, idéale pour la cuisson et la pâtisserie', 'Huiles', 3200.0, 4.4, 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg', true, 'pot 400ml', NOW(), NOW()),
('prod-008', 'Huile de Sésame Grillé', 'Huile de sésame pour cuisine asiatique, saveur intense et parfumée', 'Huiles', 2800.0, 4.3, 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg', true, 'bouteille 250ml', NOW(), NOW()),
('prod-009', 'Huile de Tournesol Bio', 'Huile de tournesol bio, neutre et polyvalente pour tous usages', 'Huiles', 1850.0, 4.1, 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg', true, 'bouteille 1L', NOW(), NOW()),

-- Ustensiles
('prod-010', 'Couteau de Chef 20cm', 'Couteau professionnel en acier inoxydable, lame forgée, manche ergonomique', 'Ustensiles', 59000.0, 4.9, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', true, 'pièce', NOW(), NOW()),
('prod-011', 'Planche à Découper Bambou', 'Planche écologique et antibactérienne, résistante et durable', 'Ustensiles', 2500.0, 4.5, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', true, 'pièce 35x25cm', NOW(), NOW()),
('prod-012', 'Set de Casseroles Inox', 'Set de 3 casseroles en inox 18/10 avec couvercles, tous feux', 'Ustensiles', 89000.0, 4.7, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', false, 'set 3 pièces', NOW(), NOW()),
('prod-013', 'Fouet Professionnel', 'Fouet en inox pour pâtisserie, 8 fils, manche antidérapant', 'Ustensiles', 1800.0, 4.6, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', true, 'pièce', NOW(), NOW()),
('prod-014', 'Mandoline Professionnelle', 'Mandoline avec lames ajustables, sécurité renforcée', 'Ustensiles', 12500.0, 4.3, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', true, 'appareil', NOW(), NOW()),
('prod-015', 'Moules à Gâteau Silicone', 'Set de 6 moules en silicone, formes variées, antiadhésif', 'Ustensiles', 3200.0, 4.4, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', true, 'set 6 pièces', NOW(), NOW()),

-- Électroménager
('prod-016', 'Mixeur Haute Performance', 'Mixeur puissant 1200W avec bol en verre, 5 vitesses', 'Électroménager', 131000.0, 4.7, 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg', true, 'appareil', NOW(), NOW()),
('prod-017', 'Robot Multifonction', 'Robot de cuisine avec 15 accessoires, pétrit, hache, râpe', 'Électroménager', 245000.0, 4.8, 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg', true, 'appareil', NOW(), NOW()),
('prod-018', 'Balance de Précision', 'Balance digitale précision 0.1g, portée 5kg, écran LCD', 'Électroménager', 4500.0, 4.4, 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg', true, 'appareil', NOW(), NOW()),
('prod-019', 'Machine à Pain', 'Machine à pain automatique, 12 programmes, cuve antiadhésive', 'Électroménager', 89000.0, 4.2, 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg', true, 'appareil', NOW(), NOW()),

-- Livres
('prod-020', 'Livre "Cuisine du Monde"', '200 recettes traditionnelles des 5 continents, photos couleur', 'Livres', 19700.0, 4.5, 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg', true, 'livre 350 pages', NOW(), NOW()),
('prod-021', 'Guide de la Pâtisserie', 'Techniques et recettes de pâtisserie française, niveau professionnel', 'Livres', 24500.0, 4.7, 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg', true, 'livre 280 pages', NOW(), NOW()),
('prod-022', 'Encyclopédie des Épices', 'Guide complet des épices du monde, origine et utilisation', 'Livres', 16800.0, 4.3, 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg', true, 'livre 200 pages', NOW(), NOW()),

-- Bio
('prod-023', 'Miel de Lavande Bio', 'Miel artisanal bio récolté en Provence, cristallisation fine', 'Bio', 10500.0, 4.8, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'pot 250g', NOW(), NOW()),
('prod-024', 'Quinoa Bio Tricolore', 'Mélange de quinoa blanc, rouge et noir, source de protéines', 'Bio', 6800.0, 4.6, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'sachet 500g', NOW(), NOW()),
('prod-025', 'Graines de Chia Bio', 'Superaliment riche en oméga-3, fibres et protéines', 'Bio', 4200.0, 4.5, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'sachet 200g', NOW(), NOW()),
('prod-026', 'Spiruline en Poudre Bio', 'Algue riche en protéines et vitamines, boost d''énergie naturel', 'Bio', 8900.0, 4.3, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'pot 100g', NOW(), NOW()),
('prod-027', 'Sucre de Coco Bio', 'Alternative naturelle au sucre blanc, index glycémique bas', 'Bio', 5400.0, 4.2, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'sachet 300g', NOW(), NOW()),
('prod-028', 'Farine d''Épeautre Bio', 'Farine ancienne, riche en protéines, digestion facilitée', 'Bio', 3800.0, 4.4, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'sachet 1kg', NOW(), NOW());

-- ==================== VIDÉOS ====================

INSERT INTO videos (id, title, description, category, duration, views, likes, video_url, thumbnail, recipe_id, created_at, updated_at) VALUES
('video-001', 'Pasta Carbonara Authentique', 'Apprenez à faire une vraie carbonara italienne avec seulement 5 ingrédients ! Technique traditionnelle romaine sans crème.', 'Plats principaux', 180, 15420, 892, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg', 'recipe-001', NOW() - INTERVAL '2 days', NOW()),

('video-002', 'Technique de Découpe des Légumes', 'Maîtrisez les techniques de découpe comme un chef professionnel. Julienne, brunoise, chiffonnade expliquées.', 'Techniques', 240, 8930, 567, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg', NULL, NOW() - INTERVAL '1 day', NOW()),

('video-003', 'Tiramisu Express', 'Un tiramisu délicieux en seulement 15 minutes ! Version rapide du classique italien avec tous les secrets.', 'Desserts', 120, 23450, 1234, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg', 'recipe-006', NOW() - INTERVAL '12 hours', NOW()),

('video-004', 'Smoothie Bowl Tropical', 'Un petit-déjeuner coloré et nutritif pour bien commencer la journée. Techniques de dressage et astuces incluses.', 'Petit-déjeuner', 90, 12340, 678, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg', 'recipe-008', NOW() - INTERVAL '6 hours', NOW()),

('video-005', 'Ratatouille Traditionnelle', 'La recette authentique de la ratatouille provençale. Techniques de cuisson et présentation comme en Provence.', 'Plats principaux', 300, 18760, 945, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/8629141/pexels-photo-8629141.jpeg', 'recipe-002', NOW() - INTERVAL '3 hours', NOW()),

('video-006', 'Salade César Parfaite', 'Les secrets d''une salade César comme au restaurant. Préparation de la sauce authentique étape par étape.', 'Entrées', 150, 9876, 543, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg', 'recipe-004', NOW() - INTERVAL '1 hour', NOW()),

('video-007', 'Croissants Maison', 'Réalisez de vrais croissants français chez vous. Technique du feuilletage expliquée pas à pas par un boulanger.', 'Boulangerie', 420, 31250, 1876, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/2067396/pexels-photo-2067396.jpeg', 'recipe-011', NOW() - INTERVAL '30 minutes', NOW()),

('video-008', 'Buddha Bowl Assembly', 'Comment assembler un buddha bowl parfait. Équilibre des saveurs, couleurs et présentation Instagram.', 'Végétarien', 180, 14520, 789, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg', 'recipe-009', NOW() - INTERVAL '2 hours', NOW()),

('video-009', 'Techniques de Base en Pâtisserie', 'Les gestes essentiels pour réussir vos pâtisseries. Crème pâtissière, pâte brisée, montage des blancs.', 'Techniques', 360, 22100, 1156, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg', NULL, NOW() - INTERVAL '4 hours', NOW()),

('video-010', 'Omelette Parfaite', 'La technique française pour une omelette parfaite. Baveuse ou bien cuite selon vos goûts, secrets de chef.', 'Rapide', 60, 7890, 445, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/824635/pexels-photo-824635.jpeg', 'recipe-010', NOW() - INTERVAL '45 minutes', NOW()),

('video-011', 'Bœuf Bourguignon Traditionnel', 'Le grand classique de la cuisine française expliqué par un chef étoilé. Tous les secrets d''un plat parfait.', 'Plats principaux', 480, 28900, 1567, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/6107787/pexels-photo-6107787.jpeg', 'recipe-003', NOW() - INTERVAL '3 days', NOW()),

('video-012', 'Tarte Tatin aux Pommes', 'La célèbre tarte renversée aux pommes caramélisées. Histoire et technique de cette pâtisserie emblématique.', 'Desserts', 300, 19450, 923, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg', 'recipe-007', NOW() - INTERVAL '4 hours', NOW()),

('video-013', 'Quiche Lorraine Traditionnelle', 'La vraie quiche lorraine avec sa pâte brisée maison. Recette authentique de Lorraine.', 'Plats principaux', 240, 16780, 834, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/4518843/pexels-photo-4518843.jpeg', 'recipe-012', NOW() - INTERVAL '45 minutes', NOW()),

('video-014', 'Velouté de Potimarron', 'Un velouté onctueux et réconfortant, parfait pour l''automne. Techniques pour un velouté parfait.', 'Entrées', 180, 11230, 567, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/539451/pexels-photo-539451.jpeg', 'recipe-005', NOW() - INTERVAL '8 hours', NOW());

-- ==================== PANIERS PRÉCONFIGURÉS ====================

INSERT INTO preconfigured_carts (id, name, description, category, total_price, items, is_active, is_featured, created_at, updated_at) VALUES
('cart-001', 'Kit Pâtisserie Complet', 'Tout pour commencer la pâtisserie comme un chef professionnel avec les meilleurs ustensiles et guides', 'Pâtisserie', 67800.0, 
 '[
   {"product_id": "prod-013", "name": "Fouet professionnel", "quantity": 1, "price": 1800.0},
   {"product_id": "prod-018", "name": "Balance de précision", "quantity": 1, "price": 4500.0},
   {"product_id": "prod-021", "name": "Guide de la Pâtisserie", "quantity": 1, "price": 24500.0},
   {"product_id": "prod-015", "name": "Moules à gâteau silicone", "quantity": 2, "price": 6400.0},
   {"product_id": "prod-016", "name": "Mixeur haute performance", "quantity": 1, "price": 131000.0}
 ]'::jsonb, true, true, NOW(), NOW()),

('cart-002', 'Épices du Monde', 'Sélection d''épices exotiques pour voyager à travers les saveurs du monde entier', 'Épices', 25850.0,
 '[
   {"product_id": "prod-001", "name": "Curcuma bio", "quantity": 2, "price": 1700.0},
   {"product_id": "prod-002", "name": "5 épices chinoises", "quantity": 2, "price": 2400.0},
   {"product_id": "prod-003", "name": "Paprika fumé", "quantity": 2, "price": 2900.0},
   {"product_id": "prod-004", "name": "Cannelle de Ceylan", "quantity": 3, "price": 4950.0},
   {"product_id": "prod-005", "name": "Herbes de Provence", "quantity": 2, "price": 1900.0},
   {"product_id": "prod-022", "name": "Encyclopédie des épices", "quantity": 1, "price": 16800.0}
 ]'::jsonb, true, true, NOW(), NOW()),

('cart-003', 'Cuisine Healthy Bio', 'Produits bio et naturels pour une cuisine saine et équilibrée au quotidien', 'Bio', 39600.0,
 '[
   {"product_id": "prod-024", "name": "Quinoa bio tricolore", "quantity": 2, "price": 13600.0},
   {"product_id": "prod-007", "name": "Huile de coco bio", "quantity": 1, "price": 3200.0},
   {"product_id": "prod-025", "name": "Graines de chia", "quantity": 2, "price": 8400.0},
   {"product_id": "prod-026", "name": "Spiruline en poudre", "quantity": 1, "price": 8900.0},
   {"product_id": "prod-027", "name": "Sucre de coco bio", "quantity": 1, "price": 5400.0},
   {"product_id": "prod-028", "name": "Farine d''épeautre bio", "quantity": 1, "price": 3800.0}
 ]'::jsonb, true, true, NOW(), NOW()),

('cart-004', 'Ustensiles Pro Chef', 'Équipement professionnel pour transformer votre cuisine en laboratoire culinaire', 'Ustensiles', 163500.0,
 '[
   {"product_id": "prod-010", "name": "Couteau de chef 20cm", "quantity": 1, "price": 59000.0},
   {"product_id": "prod-011", "name": "Planche à découper bambou", "quantity": 2, "price": 5000.0},
   {"product_id": "prod-012", "name": "Set casseroles inox", "quantity": 1, "price": 89000.0},
   {"product_id": "prod-014", "name": "Mandoline professionnelle", "quantity": 1, "price": 12500.0}
 ]'::jsonb, true, true, NOW(), NOW()),

('cart-005', 'Cuisine Méditerranéenne', 'Les essentiels pour cuisiner les saveurs ensoleillées de la Méditerranée', 'Huiles', 18400.0,
 '[
   {"product_id": "prod-006", "name": "Huile d''olive extra vierge", "quantity": 2, "price": 8500.0},
   {"product_id": "prod-003", "name": "Paprika fumé", "quantity": 2, "price": 2900.0},
   {"product_id": "prod-005", "name": "Herbes de Provence", "quantity": 2, "price": 1900.0},
   {"product_id": "prod-023", "name": "Miel de lavande bio", "quantity": 1, "price": 10500.0}
 ]'::jsonb, true, false, NOW(), NOW()),

('cart-006', 'Kit Débutant Complet', 'Parfait pour commencer en cuisine avec les bases essentielles et guides pratiques', 'Débutant', 85200.0,
 '[
   {"product_id": "prod-010", "name": "Couteau de chef", "quantity": 1, "price": 59000.0},
   {"product_id": "prod-011", "name": "Planche à découper", "quantity": 1, "price": 2500.0},
   {"product_id": "prod-020", "name": "Livre Cuisine du Monde", "quantity": 1, "price": 19700.0},
   {"product_id": "prod-018", "name": "Balance de précision", "quantity": 1, "price": 4500.0}
 ]'::jsonb, true, false, NOW(), NOW()),

('cart-007', 'Électroménager Essentiel', 'Les appareils indispensables pour une cuisine moderne et efficace', 'Électroménager', 469500.0,
 '[
   {"product_id": "prod-016", "name": "Mixeur haute performance", "quantity": 1, "price": 131000.0},
   {"product_id": "prod-017", "name": "Robot multifonction", "quantity": 1, "price": 245000.0},
   {"product_id": "prod-019", "name": "Machine à pain", "quantity": 1, "price": 89000.0},
   {"product_id": "prod-018", "name": "Balance de précision", "quantity": 1, "price": 4500.0}
 ]'::jsonb, true, false, NOW(), NOW()),

('cart-008', 'Bibliothèque Culinaire', 'Collection complète de livres pour maîtriser tous les aspects de la cuisine', 'Livres', 61000.0,
 '[
   {"product_id": "prod-020", "name": "Livre Cuisine du Monde", "quantity": 1, "price": 19700.0},
   {"product_id": "prod-021", "name": "Guide de la Pâtisserie", "quantity": 1, "price": 24500.0},
   {"product_id": "prod-022", "name": "Encyclopédie des épices", "quantity": 1, "price": 16800.0}
 ]'::jsonb, true, false, NOW(), NOW());

-- ==================== FAVORIS (exemples) ====================

INSERT INTO favorites (user_id, item_id, type, created_at) VALUES
-- Favoris de Marie Dubois
('550e8400-e29b-41d4-a716-446655440001', 'recipe-001', 'recipe', NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-006', 'recipe', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-011', 'recipe', NOW() - INTERVAL '30 minutes'),
('550e8400-e29b-41d4-a716-446655440001', 'prod-006', 'product', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'prod-021', 'product', NOW() - INTERVAL '1 day'),

-- Favoris de Pierre Martin
('550e8400-e29b-41d4-a716-446655440002', 'recipe-002', 'recipe', NOW() - INTERVAL '2 days'),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-009', 'recipe', NOW() - INTERVAL '4 hours'),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-007', 'recipe', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440002', 'prod-024', 'product', NOW() - INTERVAL '6 hours'),

-- Favoris de Sophie Laurent
('550e8400-e29b-41d4-a716-446655440003', 'recipe-004', 'recipe', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440003', 'recipe-010', 'recipe', NOW() - INTERVAL '45 minutes'),
('550e8400-e29b-41d4-a716-446655440003', 'prod-010', 'product', NOW() - INTERVAL '2 days'),
('550e8400-e29b-41d4-a716-446655440003', 'prod-013', 'product', NOW() - INTERVAL '5 hours'),

-- Favoris de Thomas Bernard
('550e8400-e29b-41d4-a716-446655440004', 'recipe-008', 'recipe', NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440004', 'recipe-005', 'recipe', NOW() - INTERVAL '8 hours'),
('550e8400-e29b-41d4-a716-446655440004', 'prod-025', 'product', NOW() - INTERVAL '12 hours'),

-- Favoris de Julie Moreau
('550e8400-e29b-41d4-a716-446655440005', 'recipe-012', 'recipe', NOW() - INTERVAL '30 minutes'),
('550e8400-e29b-41d4-a716-446655440005', 'recipe-003', 'recipe', NOW() - INTERVAL '2 days'),
('550e8400-e29b-41d4-a716-446655440005', 'prod-017', 'product', NOW() - INTERVAL '1 day');

-- ==================== HISTORIQUE (exemples) ====================

INSERT INTO user_history (user_id, recipe_id, viewed_at) VALUES
-- Historique de Marie Dubois
('550e8400-e29b-41d4-a716-446655440001', 'recipe-001', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-006', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-011', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-007', NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-002', NOW() - INTERVAL '2 days'),

-- Historique de Pierre Martin
('550e8400-e29b-41d4-a716-446655440002', 'recipe-009', NOW() - INTERVAL '30 minutes'),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-002', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-007', NOW() - INTERVAL '5 hours'),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-004', NOW() - INTERVAL '1 day'),

-- Historique de Sophie Laurent
('550e8400-e29b-41d4-a716-446655440003', 'recipe-010', NOW() - INTERVAL '15 minutes'),
('550e8400-e29b-41d4-a716-446655440003', 'recipe-004', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440003', 'recipe-012', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440003', 'recipe-008', NOW() - INTERVAL '6 hours'),

-- Historique de Thomas Bernard
('550e8400-e29b-41d4-a716-446655440004', 'recipe-008', NOW() - INTERVAL '45 minutes'),
('550e8400-e29b-41d4-a716-446655440004', 'recipe-005', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440004', 'recipe-009', NOW() - INTERVAL '4 hours'),

-- Historique de Julie Moreau
('550e8400-e29b-41d4-a716-446655440005', 'recipe-012', NOW() - INTERVAL '20 minutes'),
('550e8400-e29b-41d4-a716-446655440005', 'recipe-003', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440005', 'recipe-001', NOW() - INTERVAL '3 hours');

-- ==================== PANIERS UTILISATEURS (exemples) ====================

-- Créer des paniers principaux pour les utilisateurs
INSERT INTO user_carts (id, user_id, total_price, created_at, updated_at) VALUES
('cart-user-001', '550e8400-e29b-41d4-a716-446655440001', 67800.0, NOW() - INTERVAL '1 day', NOW()),
('cart-user-002', '550e8400-e29b-41d4-a716-446655440002', 25850.0, NOW() - INTERVAL '2 hours', NOW()),
('cart-user-003', '550e8400-e29b-41d4-a716-446655440003', 163500.0, NOW() - INTERVAL '30 minutes', NOW());

-- Ajouter des items aux paniers principaux (paniers préconfigurés)
INSERT INTO user_cart_items (user_cart_id, cart_reference_type, cart_reference_id, cart_name, cart_total_price, items_count, created_at) VALUES
('cart-user-001', 'preconfigured', 'cart-001', 'Kit Pâtisserie Complet', 67800.0, 5, NOW() - INTERVAL '1 day'),
('cart-user-002', 'preconfigured', 'cart-002', 'Épices du Monde', 25850.0, 6, NOW() - INTERVAL '2 hours'),
('cart-user-003', 'preconfigured', 'cart-004', 'Ustensiles Pro Chef', 163500.0, 4, NOW() - INTERVAL '30 minutes');

-- Créer des paniers personnels
INSERT INTO personal_carts (id, user_id, is_added_to_main_cart, created_at, updated_at) VALUES
('personal-001', '550e8400-e29b-41d4-a716-446655440001', true, NOW() - INTERVAL '2 days', NOW()),
('personal-002', '550e8400-e29b-41d4-a716-446655440003', false, NOW() - INTERVAL '1 hour', NOW()),
('personal-003', '550e8400-e29b-41d4-a716-446655440004', false, NOW() - INTERVAL '3 hours', NOW());

-- Ajouter des produits aux paniers personnels
INSERT INTO personal_cart_items (personal_cart_id, product_id, quantity, created_at) VALUES
-- Panier personnel de Marie
('personal-001', 'prod-006', 2, NOW() - INTERVAL '2 days'),
('personal-001', 'prod-023', 1, NOW() - INTERVAL '1 day'),
('personal-001', 'prod-020', 1, NOW() - INTERVAL '12 hours'),

-- Panier personnel de Sophie
('personal-002', 'prod-010', 1, NOW() - INTERVAL '1 hour'),
('personal-002', 'prod-011', 2, NOW() - INTERVAL '45 minutes'),

-- Panier personnel de Thomas
('personal-003', 'prod-024', 1, NOW() - INTERVAL '3 hours'),
('personal-003', 'prod-025', 2, NOW() - INTERVAL '2 hours'),
('personal-003', 'prod-007', 1, NOW() - INTERVAL '1 hour');

-- Créer des paniers recette
INSERT INTO recipe_user_carts (id, user_id, recipe_id, cart_name, is_added_to_main_cart, created_at) VALUES
('recipe-cart-001', '550e8400-e29b-41d4-a716-446655440002', 'recipe-001', 'Ingrédients Carbonara', true, NOW() - INTERVAL '1 day'),
('recipe-cart-002', '550e8400-e29b-41d4-a716-446655440004', 'recipe-008', 'Ingrédients Smoothie Bowl', false, NOW() - INTERVAL '2 hours'),
('recipe-cart-003', '550e8400-e29b-41d4-a716-446655440005', 'recipe-003', 'Ingrédients Bœuf Bourguignon', false, NOW() - INTERVAL '4 hours');

-- Ajouter des produits aux paniers recette
INSERT INTO recipe_cart_items (recipe_cart_id, product_id, quantity, created_at) VALUES
-- Panier recette Carbonara
('recipe-cart-001', 'prod-006', 1, NOW() - INTERVAL '1 day'),
('recipe-cart-001', 'prod-001', 1, NOW() - INTERVAL '1 day'),

-- Panier recette Smoothie Bowl
('recipe-cart-002', 'prod-023', 1, NOW() - INTERVAL '2 hours'),
('recipe-cart-002', 'prod-025', 1, NOW() - INTERVAL '2 hours'),
('recipe-cart-002', 'prod-007', 1, NOW() - INTERVAL '2 hours'),

-- Panier recette Bœuf Bourguignon
('recipe-cart-003', 'prod-006', 1, NOW() - INTERVAL '4 hours'),
('recipe-cart-003', 'prod-005', 1, NOW() - INTERVAL '4 hours');

-- Lier des paniers préconfigurés aux utilisateurs
INSERT INTO user_preconfigured_carts (user_id, preconfigured_cart_id, is_added_to_main_cart, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'cart-001', true, NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440002', 'cart-002', true, NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440003', 'cart-004', true, NOW() - INTERVAL '30 minutes'),
('550e8400-e29b-41d4-a716-446655440004', 'cart-003', false, NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440005', 'cart-006', false, NOW() - INTERVAL '3 hours');

-- Mettre à jour les totaux des paniers principaux
UPDATE user_carts SET total_price = (
  SELECT COALESCE(SUM(cart_total_price), 0)
  FROM user_cart_items 
  WHERE user_cart_id = user_carts.id
), updated_at = NOW() WHERE id IN ('cart-user-001', 'cart-user-002', 'cart-user-003');

-- ==================== STATISTIQUES FINALES ====================
-- Afficher un résumé des données insérées

DO $$
BEGIN
  RAISE NOTICE '=== DATA SEEDING TERMINÉ ===';
  RAISE NOTICE 'Profils utilisateurs: %', (SELECT COUNT(*) FROM profiles);
  RAISE NOTICE 'Recettes: %', (SELECT COUNT(*) FROM recipes);
  RAISE NOTICE 'Produits: %', (SELECT COUNT(*) FROM products);
  RAISE NOTICE 'Vidéos: %', (SELECT COUNT(*) FROM videos);
  RAISE NOTICE 'Paniers préconfigurés: %', (SELECT COUNT(*) FROM preconfigured_carts);
  RAISE NOTICE 'Favoris: %', (SELECT COUNT(*) FROM favorites);
  RAISE NOTICE 'Historique: %', (SELECT COUNT(*) FROM user_history);
  RAISE NOTICE 'Paniers utilisateurs: %', (SELECT COUNT(*) FROM user_carts);
  RAISE NOTICE '=== SEEDING RÉUSSI ===';
END $$;