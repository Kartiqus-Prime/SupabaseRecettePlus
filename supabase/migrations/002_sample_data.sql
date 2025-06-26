-- Insert sample recipes
INSERT INTO public.recipes (title, description, category, prep_time, cook_time, servings, difficulty, rating, ingredients, instructions, is_active) VALUES
('Pasta Carbonara', 'Un classique italien crémeux et délicieux', 'Plats principaux', 10, 15, 4, 'Facile', 4.8, 
 '["400g de spaghetti", "200g de pancetta", "4 œufs", "100g de parmesan", "Poivre noir", "Sel"]',
 '["Faire cuire les pâtes", "Faire revenir la pancetta", "Mélanger œufs et parmesan", "Combiner le tout"]',
 true),

('Salade César', 'Salade fraîche avec croûtons et parmesan', 'Entrées', 15, 0, 2, 'Facile', 4.5,
 '["Laitue romaine", "Croûtons", "Parmesan", "Sauce césar", "Anchois"]',
 '["Laver la salade", "Préparer les croûtons", "Mélanger avec la sauce"]',
 true),

('Tiramisu', 'Dessert italien au café et mascarpone', 'Desserts', 30, 0, 6, 'Moyen', 4.9,
 '["Mascarpone", "Œufs", "Sucre", "Café", "Biscuits à la cuillère", "Cacao"]',
 '["Préparer la crème", "Tremper les biscuits", "Monter en couches", "Réfrigérer"]',
 true);

-- Insert sample products
INSERT INTO public.products (name, description, price, category, stock, is_active) VALUES
('Huile d''olive extra vierge', 'Huile d''olive premium de première pression à froid', 12.99, 'Huiles', 50, true),
('Set d''épices du monde', 'Collection de 12 épices exotiques', 24.99, 'Épices', 30, true),
('Couteau de chef professionnel', 'Couteau en acier inoxydable de haute qualité', 89.99, 'Ustensiles', 15, true),
('Mixeur haute performance', 'Mixeur puissant pour smoothies et soupes', 199.99, 'Électroménager', 10, true),
('Livre "Cuisine du monde"', '200 recettes traditionnelles du monde entier', 29.99, 'Livres', 25, true),
('Miel bio de lavande', 'Miel artisanal bio récolté en Provence', 15.99, 'Bio', 40, true);

-- Insert sample videos
INSERT INTO public.videos (title, description, video_url, category, duration, is_active) VALUES
('Comment faire des pâtes parfaites', 'Technique pour réussir ses pâtes à tous les coups', 'https://example.com/video1', 'Techniques', 300, true),
('Découpe des légumes comme un chef', 'Maîtrisez les techniques de découpe professionnelles', 'https://example.com/video2', 'Techniques', 450, true),
('Recette express: Omelette aux herbes', 'Une omelette parfaite en 5 minutes', 'https://example.com/video3', 'Recettes rapides', 180, true);
