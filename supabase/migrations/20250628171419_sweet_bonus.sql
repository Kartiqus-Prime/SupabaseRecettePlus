/*
  # Data Seeding Complet pour Recette+

  1. Suppression des données existantes
  2. Insertion des données de test avec relations
  3. Création des profils utilisateurs
  4. Insertion des recettes avec catégories
  5. Insertion des produits avec catégories
  6. Insertion des vidéos liées aux recettes
  7. Insertion des paniers préconfigurés avec articles
  8. Configuration des permissions et données admin
*/

-- Supprimer toutes les données existantes (dans l'ordre des dépendances)
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

-- Réinitialiser les séquences si elles existent
-- (Les UUIDs n'ont pas de séquences, mais on s'assure que tout est propre)

-- ==================== PROFILS UTILISATEURS ====================

INSERT INTO profiles (id, display_name, email, phone_number, role, created_at, updated_at) VALUES
-- Utilisateur admin
('550e8400-e29b-41d4-a716-446655440000', 'Admin Recette+', 'admin@recetteplus.com', '+33123456789', 'admin', NOW(), NOW()),
-- Utilisateurs normaux
('550e8400-e29b-41d4-a716-446655440001', 'Marie Dubois', 'marie.dubois@email.com', '+33123456790', 'user', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'Pierre Martin', 'pierre.martin@email.com', '+33123456791', 'user', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440003', 'Sophie Laurent', 'sophie.laurent@email.com', '+33123456792', 'user', NOW(), NOW()),
('550e8400-e29b-41d4-a716-446655440004', 'Thomas Bernard', 'thomas.bernard@email.com', NULL, 'user', NOW(), NOW());

-- ==================== PERMISSIONS ADMIN ====================

INSERT INTO admin_permissions (user_id, is_super_admin, can_manage_users, can_manage_content, can_view_analytics, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440000', true, true, true, true, NOW());

-- ==================== RECETTES ====================

INSERT INTO recipes (id, title, description, category, cook_time, prep_time, servings, difficulty, rating, image_url, ingredients, instructions, created_by, is_active, created_at, updated_at) VALUES
-- Plats principaux
('recipe-001', 'Pasta Carbonara Authentique', 'Un classique italien crémeux et délicieux avec seulement 5 ingrédients. La vraie recette romaine sans crème !', 'Plats principaux', 20, 10, 4, 'Facile', 4.8, 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg', 
 '["400g de spaghetti", "200g de pancetta ou guanciale", "4 œufs entiers", "100g de parmesan râpé", "Poivre noir fraîchement moulu", "Sel"]',
 '["Faire cuire les pâtes dans une grande casserole d''eau salée", "Faire revenir la pancetta dans une poêle jusqu''à ce qu''elle soit croustillante", "Battre les œufs avec le parmesan et le poivre dans un bol", "Égoutter les pâtes en réservant un peu d''eau de cuisson", "Mélanger rapidement les pâtes chaudes avec le mélange œuf-fromage", "Ajouter la pancetta et un peu d''eau de cuisson si nécessaire", "Servir immédiatement avec du parmesan supplémentaire"]',
 '550e8400-e29b-41d4-a716-446655440001', true, NOW() - INTERVAL '2 days', NOW()),

('recipe-002', 'Ratatouille Traditionnelle', 'La recette authentique de la ratatouille provençale, un plat végétarien coloré et savoureux', 'Plats principaux', 45, 20, 6, 'Moyen', 4.6, 'https://images.pexels.com/photos/8629141/pexels-photo-8629141.jpeg',
 '["2 aubergines", "3 courgettes", "2 poivrons rouges", "4 tomates", "1 oignon", "4 gousses d''ail", "Herbes de Provence", "Huile d''olive", "Sel et poivre"]',
 '["Couper tous les légumes en dés réguliers", "Faire revenir l''oignon et l''ail dans l''huile d''olive", "Ajouter les aubergines et faire cuire 10 minutes", "Incorporer les courgettes et poivrons", "Ajouter les tomates et les herbes", "Laisser mijoter 30 minutes à feu doux", "Rectifier l''assaisonnement et servir chaud"]',
 '550e8400-e29b-41d4-a716-446655440002', true, NOW() - INTERVAL '1 day', NOW()),

-- Entrées
('recipe-003', 'Salade César Parfaite', 'La vraie salade César avec sa sauce crémeuse et ses croûtons croustillants', 'Entrées', 15, 15, 2, 'Facile', 4.5, 'https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg',
 '["2 cœurs de laitue romaine", "100g de parmesan", "4 tranches de pain", "2 gousses d''ail", "2 jaunes d''œuf", "6 filets d''anchois", "Jus de citron", "Huile d''olive", "Moutarde de Dijon"]',
 '["Préparer les croûtons en faisant griller le pain avec de l''ail", "Laver et couper la salade en morceaux", "Préparer la sauce en mélangeant jaunes d''œuf, anchois, moutarde et citron", "Monter la sauce à l''huile d''olive", "Mélanger la salade avec la sauce", "Ajouter les croûtons et le parmesan râpé", "Servir immédiatement"]',
 '550e8400-e29b-41d4-a716-446655440003', true, NOW() - INTERVAL '12 hours', NOW()),

-- Desserts
('recipe-004', 'Tiramisu Express', 'Version rapide du célèbre dessert italien, prêt en 15 minutes', 'Desserts', 15, 15, 6, 'Facile', 4.9, 'https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg',
 '["500g de mascarpone", "6 jaunes d''œuf", "100g de sucre", "300ml de café fort refroidi", "2 paquets de biscuits à la cuillère", "Cacao en poudre", "Amaretto (optionnel)"]',
 '["Battre les jaunes d''œuf avec le sucre jusqu''à blanchiment", "Incorporer délicatement le mascarpone", "Tremper rapidement les biscuits dans le café", "Disposer une couche de biscuits dans le plat", "Recouvrir de crème au mascarpone", "Répéter l''opération", "Saupoudrer de cacao et réfrigérer 2h minimum"]',
 '550e8400-e29b-41d4-a716-446655440001', true, NOW() - INTERVAL '6 hours', NOW()),

-- Boissons
('recipe-005', 'Smoothie Bowl Tropical', 'Un petit-déjeuner coloré et nutritif aux fruits exotiques', 'Boissons', 5, 10, 1, 'Facile', 4.3, 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg',
 '["1 mangue mûre", "1/2 ananas", "1 banane", "200ml de lait de coco", "1 cuillère de miel", "Granola", "Noix de coco râpée", "Fruits rouges"]',
 '["Éplucher et couper les fruits en morceaux", "Mixer mangue, ananas et banane avec le lait de coco", "Ajouter le miel et mixer à nouveau", "Verser dans un bol", "Décorer avec granola, coco râpée et fruits rouges", "Servir immédiatement"]',
 '550e8400-e29b-41d4-a716-446655440004', true, NOW() - INTERVAL '3 hours', NOW()),

-- Végétarien
('recipe-006', 'Buddha Bowl Nutritif', 'Bol complet végétarien avec quinoa et légumes de saison', 'Végétarien', 25, 15, 2, 'Facile', 4.6, 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
 '["150g de quinoa", "1 avocat", "200g de brocolis", "1 betterave cuite", "100g d''épinards", "50g de graines de tournesol", "Sauce tahini", "Huile d''olive", "Citron"]',
 '["Cuire le quinoa selon les instructions", "Faire cuire les brocolis à la vapeur", "Couper l''avocat et la betterave en tranches", "Préparer la sauce tahini avec citron et huile", "Disposer tous les ingrédients dans un bol", "Arroser de sauce et parsemer de graines", "Servir tiède ou froid"]',
 '550e8400-e29b-41d4-a716-446655440002', true, NOW() - INTERVAL '2 hours', NOW()),

-- Rapide
('recipe-007', 'Omelette Express', 'Petit-déjeuner rapide et protéiné en moins de 10 minutes', 'Rapide', 8, 2, 1, 'Facile', 4.2, 'https://images.pexels.com/photos/824635/pexels-photo-824635.jpeg',
 '["3 œufs frais", "20g de beurre", "50g de fromage râpé", "Herbes fraîches", "Sel et poivre"]',
 '["Battre les œufs avec sel et poivre", "Chauffer le beurre dans une poêle antiadhésive", "Verser les œufs et laisser prendre", "Ajouter le fromage sur une moitié", "Plier l''omelette en deux", "Parsemer d''herbes et servir chaud"]',
 '550e8400-e29b-41d4-a716-446655440003', true, NOW() - INTERVAL '1 hour', NOW()),

('recipe-008', 'Croissants Maison', 'Réalisez de vrais croissants français chez vous avec cette recette détaillée', 'Boulangerie', 420, 180, 8, 'Difficile', 4.8, 'https://images.pexels.com/photos/2067396/pexels-photo-2067396.jpeg',
 '["500g de farine T55", "10g de sel", "50g de sucre", "10g de levure fraîche", "300ml de lait tiède", "250g de beurre froid", "1 œuf pour dorure"]',
 '["Mélanger farine, sel et sucre", "Diluer la levure dans le lait tiède", "Pétrir la pâte et laisser lever 1h", "Étaler le beurre en rectangle", "Incorporer le beurre par tourage", "Effectuer 3 tours avec repos au frigo", "Détailler et façonner les croissants", "Laisser lever 2h puis cuire 15min à 200°C"]',
 '550e8400-e29b-41d4-a716-446655440001', true, NOW() - INTERVAL '30 minutes', NOW());

-- ==================== PRODUITS ====================

INSERT INTO products (id, name, description, category, price, rating, image_url, in_stock, unit, created_at, updated_at) VALUES
-- Épices
('prod-001', 'Curcuma Bio en Poudre', 'Curcuma bio de qualité premium, anti-inflammatoire naturel', 'Épices', 850.0, 4.7, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'pot 100g', NOW(), NOW()),
('prod-002', 'Mélange 5 Épices Chinoises', 'Mélange traditionnel pour cuisine asiatique', 'Épices', 1200.0, 4.5, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'sachet 50g', NOW(), NOW()),
('prod-003', 'Paprika Fumé de La Vera', 'Paprika espagnol fumé au bois de chêne', 'Épices', 1450.0, 4.8, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'boîte 75g', NOW(), NOW()),
('prod-004', 'Cannelle de Ceylan Bâtons', 'Vraie cannelle de Ceylan, arôme délicat', 'Épices', 1650.0, 4.6, 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg', true, 'sachet 30g', NOW(), NOW()),

-- Huiles
('prod-005', 'Huile d\'Olive Extra Vierge', 'Huile d\'olive premium de première pression à froid', 'Huiles', 4250.0, 4.8, 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg', true, 'bouteille 500ml', NOW(), NOW()),
('prod-006', 'Huile de Coco Vierge Bio', 'Huile de coco pure, idéale pour la cuisson', 'Huiles', 3200.0, 4.4, 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg', true, 'pot 400ml', NOW(), NOW()),
('prod-007', 'Huile de Sésame Grillé', 'Huile de sésame pour cuisine asiatique', 'Huiles', 2800.0, 4.3, 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg', true, 'bouteille 250ml', NOW(), NOW()),

-- Ustensiles
('prod-008', 'Couteau de Chef 20cm', 'Couteau professionnel en acier inoxydable', 'Ustensiles', 59000.0, 4.9, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', true, 'pièce', NOW(), NOW()),
('prod-009', 'Planche à Découper Bambou', 'Planche écologique et antibactérienne', 'Ustensiles', 2500.0, 4.5, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', true, 'pièce 35x25cm', NOW(), NOW()),
('prod-010', 'Set de Casseroles Inox', 'Set de 3 casseroles en inox 18/10', 'Ustensiles', 89000.0, 4.7, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', false, 'set 3 pièces', NOW(), NOW()),
('prod-011', 'Fouet Professionnel', 'Fouet en inox pour pâtisserie', 'Ustensiles', 1800.0, 4.6, 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg', true, 'pièce', NOW(), NOW()),

-- Électroménager
('prod-012', 'Mixeur Haute Performance', 'Mixeur puissant 1200W avec bol en verre', 'Électroménager', 131000.0, 4.7, 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg', true, 'appareil', NOW(), NOW()),
('prod-013', 'Robot Multifonction', 'Robot de cuisine avec 15 accessoires', 'Électroménager', 245000.0, 4.8, 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg', true, 'appareil', NOW(), NOW()),
('prod-014', 'Balance de Précision', 'Balance digitale précision 0.1g', 'Électroménager', 4500.0, 4.4, 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg', true, 'appareil', NOW(), NOW()),

-- Livres
('prod-015', 'Livre "Cuisine du Monde"', '200 recettes traditionnelles des 5 continents', 'Livres', 19700.0, 4.5, 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg', true, 'livre 350 pages', NOW(), NOW()),
('prod-016', 'Guide de la Pâtisserie', 'Techniques et recettes de pâtisserie française', 'Livres', 24500.0, 4.7, 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg', true, 'livre 280 pages', NOW(), NOW()),

-- Bio
('prod-017', 'Miel de Lavande Bio', 'Miel artisanal bio récolté en Provence', 'Bio', 10500.0, 4.8, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'pot 250g', NOW(), NOW()),
('prod-018', 'Quinoa Bio Tricolore', 'Mélange de quinoa blanc, rouge et noir', 'Bio', 6800.0, 4.6, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'sachet 500g', NOW(), NOW()),
('prod-019', 'Graines de Chia Bio', 'Superaliment riche en oméga-3', 'Bio', 4200.0, 4.5, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'sachet 200g', NOW(), NOW()),
('prod-020', 'Spiruline en Poudre Bio', 'Algue riche en protéines et vitamines', 'Bio', 8900.0, 4.3, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg', true, 'pot 100g', NOW(), NOW());

-- ==================== VIDÉOS ====================

INSERT INTO videos (id, title, description, category, duration, views, likes, video_url, thumbnail, recipe_id, created_at, updated_at) VALUES
('video-001', 'Pasta Carbonara Authentique', 'Apprenez à faire une vraie carbonara italienne avec seulement 5 ingrédients ! Technique traditionnelle romaine.', 'Plats principaux', 180, 15420, 892, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg', 'recipe-001', NOW() - INTERVAL '2 days', NOW()),

('video-002', 'Technique de Découpe des Légumes', 'Maîtrisez les techniques de découpe comme un chef professionnel. Julienne, brunoise, chiffonnade...', 'Techniques', 240, 8930, 567, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg', NULL, NOW() - INTERVAL '1 day', NOW()),

('video-003', 'Tiramisu Express', 'Un tiramisu délicieux en seulement 15 minutes ! Version rapide du classique italien.', 'Desserts', 120, 23450, 1234, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg', 'recipe-004', NOW() - INTERVAL '12 hours', NOW()),

('video-004', 'Smoothie Bowl Tropical', 'Un petit-déjeuner coloré et nutritif pour bien commencer la journée. Techniques de dressage incluses.', 'Petit-déjeuner', 90, 12340, 678, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg', 'recipe-005', NOW() - INTERVAL '6 hours', NOW()),

('video-005', 'Ratatouille Traditionnelle', 'La recette authentique de la ratatouille provençale. Techniques de cuisson et présentation.', 'Plats principaux', 300, 18760, 945, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/8629141/pexels-photo-8629141.jpeg', 'recipe-002', NOW() - INTERVAL '3 hours', NOW()),

('video-006', 'Salade César Parfaite', 'Les secrets d''une salade César comme au restaurant. Préparation de la sauce authentique.', 'Entrées', 150, 9876, 543, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg', 'recipe-003', NOW() - INTERVAL '1 hour', NOW()),

('video-007', 'Croissants Maison', 'Réalisez de vrais croissants français chez vous. Technique du feuilletage expliquée pas à pas.', 'Boulangerie', 420, 31250, 1876, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/2067396/pexels-photo-2067396.jpeg', 'recipe-008', NOW() - INTERVAL '30 minutes', NOW()),

('video-008', 'Buddha Bowl Assembly', 'Comment assembler un buddha bowl parfait. Équilibre des saveurs et présentation.', 'Végétarien', 180, 14520, 789, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg', 'recipe-006', NOW() - INTERVAL '2 hours', NOW()),

('video-009', 'Techniques de Base en Pâtisserie', 'Les gestes essentiels pour réussir vos pâtisseries. Crème pâtissière, pâte brisée...', 'Techniques', 360, 22100, 1156, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg', NULL, NOW() - INTERVAL '4 hours', NOW()),

('video-010', 'Omelette Parfaite', 'La technique française pour une omelette parfaite. Baveuse ou bien cuite selon vos goûts.', 'Rapide', 60, 7890, 445, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/824635/pexels-photo-824635.jpeg', 'recipe-007', NOW() - INTERVAL '45 minutes', NOW());

-- ==================== PANIERS PRÉCONFIGURÉS ====================

INSERT INTO preconfigured_carts (id, name, description, category, total_price, items, is_active, is_featured, created_at, updated_at) VALUES
('cart-001', 'Kit Pâtisserie Complet', 'Tout pour commencer la pâtisserie comme un chef professionnel avec les meilleurs ustensiles et ingrédients de base', 'Pâtisserie', 45000.0, 
 '[
   {"product_id": "prod-011", "name": "Fouet professionnel", "quantity": 1, "price": 1800.0},
   {"product_id": "prod-014", "name": "Balance de précision", "quantity": 1, "price": 4500.0},
   {"product_id": "prod-016", "name": "Guide de la Pâtisserie", "quantity": 1, "price": 24500.0},
   {"product_id": "prod-012", "name": "Mixeur haute performance", "quantity": 1, "price": 14200.0}
 ]'::jsonb, true, true, NOW(), NOW()),

('cart-002', 'Épices du Monde', 'Sélection d''épices exotiques pour voyager à travers les saveurs du monde entier', 'Épices', 32000.0,
 '[
   {"product_id": "prod-001", "name": "Curcuma bio", "quantity": 2, "price": 1700.0},
   {"product_id": "prod-002", "name": "5 épices chinoises", "quantity": 3, "price": 3600.0},
   {"product_id": "prod-003", "name": "Paprika fumé", "quantity": 2, "price": 2900.0},
   {"product_id": "prod-004", "name": "Cannelle de Ceylan", "quantity": 4, "price": 6600.0},
   {"product_id": "prod-015", "name": "Livre Cuisine du Monde", "quantity": 1, "price": 19700.0}
 ]'::jsonb, true, true, NOW(), NOW()),

('cart-003', 'Cuisine Healthy', 'Produits bio et naturels pour une cuisine saine et équilibrée au quotidien', 'Bio', 28500.0,
 '[
   {"product_id": "prod-018", "name": "Quinoa bio tricolore", "quantity": 2, "price": 13600.0},
   {"product_id": "prod-006", "name": "Huile de coco bio", "quantity": 1, "price": 3200.0},
   {"product_id": "prod-019", "name": "Graines de chia", "quantity": 2, "price": 8400.0},
   {"product_id": "prod-020", "name": "Spiruline en poudre", "quantity": 1, "price": 8900.0}
 ]'::jsonb, true, true, NOW(), NOW()),

('cart-004', 'Ustensiles Pro', 'Équipement professionnel pour transformer votre cuisine en laboratoire culinaire', 'Ustensiles', 89000.0,
 '[
   {"product_id": "prod-008", "name": "Couteau de chef 20cm", "quantity": 1, "price": 59000.0},
   {"product_id": "prod-009", "name": "Planche à découper bambou", "quantity": 2, "price": 5000.0},
   {"product_id": "prod-010", "name": "Set casseroles inox", "quantity": 1, "price": 89000.0}
 ]'::jsonb, true, true, NOW(), NOW()),

('cart-005', 'Cuisine Méditerranéenne', 'Les essentiels pour cuisiner les saveurs ensoleillées de la Méditerranée', 'Huiles', 18500.0,
 '[
   {"product_id": "prod-005", "name": "Huile d''olive extra vierge", "quantity": 2, "price": 8500.0},
   {"product_id": "prod-003", "name": "Paprika fumé", "quantity": 2, "price": 2900.0},
   {"product_id": "prod-017", "name": "Miel de lavande bio", "quantity": 1, "price": 10500.0}
 ]'::jsonb, true, false, NOW(), NOW()),

('cart-006', 'Kit Débutant', 'Parfait pour commencer en cuisine avec les bases essentielles et un guide pratique', 'Débutant', 35000.0,
 '[
   {"product_id": "prod-008", "name": "Couteau de chef", "quantity": 1, "price": 59000.0},
   {"product_id": "prod-009", "name": "Planche à découper", "quantity": 1, "price": 2500.0},
   {"product_id": "prod-015", "name": "Livre Cuisine du Monde", "quantity": 1, "price": 19700.0}
 ]'::jsonb, true, false, NOW(), NOW());

-- ==================== FAVORIS (exemples) ====================

INSERT INTO favorites (user_id, item_id, type, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'recipe-001', 'recipe', NOW()),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-004', 'recipe', NOW()),
('550e8400-e29b-41d4-a716-446655440001', 'prod-005', 'product', NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-002', 'recipe', NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-006', 'recipe', NOW()),
('550e8400-e29b-41d4-a716-446655440003', 'recipe-003', 'recipe', NOW()),
('550e8400-e29b-41d4-a716-446655440003', 'prod-008', 'product', NOW());

-- ==================== HISTORIQUE (exemples) ====================

INSERT INTO user_history (user_id, recipe_id, viewed_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'recipe-001', NOW() - INTERVAL '1 hour'),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-004', NOW() - INTERVAL '2 hours'),
('550e8400-e29b-41d4-a716-446655440001', 'recipe-002', NOW() - INTERVAL '1 day'),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-006', NOW() - INTERVAL '30 minutes'),
('550e8400-e29b-41d4-a716-446655440002', 'recipe-003', NOW() - INTERVAL '3 hours'),
('550e8400-e29b-41d4-a716-446655440003', 'recipe-005', NOW() - INTERVAL '45 minutes'),
('550e8400-e29b-41d4-a716-446655440004', 'recipe-007', NOW() - INTERVAL '15 minutes');

-- ==================== PANIERS UTILISATEURS (exemples) ====================

-- Créer des paniers principaux pour les utilisateurs
INSERT INTO user_carts (id, user_id, total_price, created_at, updated_at) VALUES
('cart-user-001', '550e8400-e29b-41d4-a716-446655440001', 15750.0, NOW(), NOW()),
('cart-user-002', '550e8400-e29b-41d4-a716-446655440002', 32000.0, NOW(), NOW());

-- Ajouter des items aux paniers principaux
INSERT INTO user_cart_items (user_cart_id, cart_reference_type, cart_reference_id, cart_name, cart_total_price, items_count, created_at) VALUES
('cart-user-001', 'preconfigured', 'cart-003', 'Cuisine Healthy', 28500.0, 6, NOW()),
('cart-user-002', 'preconfigured', 'cart-002', 'Épices du Monde', 32000.0, 12, NOW());

-- Créer des paniers personnels
INSERT INTO personal_carts (id, user_id, is_added_to_main_cart, created_at, updated_at) VALUES
('personal-001', '550e8400-e29b-41d4-a716-446655440001', true, NOW(), NOW()),
('personal-002', '550e8400-e29b-41d4-a716-446655440003', false, NOW(), NOW());

-- Ajouter des produits aux paniers personnels
INSERT INTO personal_cart_items (personal_cart_id, product_id, quantity, created_at) VALUES
('personal-001', 'prod-005', 2, NOW()),
('personal-001', 'prod-017', 1, NOW()),
('personal-002', 'prod-008', 1, NOW()),
('personal-002', 'prod-009', 1, NOW());

-- Créer des paniers recette
INSERT INTO recipe_user_carts (id, user_id, recipe_id, cart_name, is_added_to_main_cart, created_at) VALUES
('recipe-cart-001', '550e8400-e29b-41d4-a716-446655440002', 'recipe-001', 'Ingrédients Carbonara', true, NOW()),
('recipe-cart-002', '550e8400-e29b-41d4-a716-446655440004', 'recipe-005', 'Ingrédients Smoothie Bowl', false, NOW());

-- Ajouter des produits aux paniers recette
INSERT INTO recipe_cart_items (recipe_cart_id, product_id, quantity, created_at) VALUES
('recipe-cart-001', 'prod-005', 1, NOW()),
('recipe-cart-002', 'prod-017', 1, NOW()),
('recipe-cart-002', 'prod-019', 1, NOW());

-- Lier des paniers préconfigurés aux utilisateurs
INSERT INTO user_preconfigured_carts (user_id, preconfigured_cart_id, is_added_to_main_cart, created_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'cart-001', true, NOW()),
('550e8400-e29b-41d4-a716-446655440002', 'cart-002', true, NOW()),
('550e8400-e29b-41d4-a716-446655440003', 'cart-004', false, NOW());

-- Mettre à jour les totaux des paniers principaux
UPDATE user_carts SET total_price = (
  SELECT COALESCE(SUM(cart_total_price), 0)
  FROM user_cart_items 
  WHERE user_cart_id = user_carts.id
) WHERE id IN ('cart-user-001', 'cart-user-002');