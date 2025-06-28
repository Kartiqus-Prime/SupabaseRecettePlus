-- Fonctions pour gérer les vues et likes des vidéos

-- Fonction pour incrémenter les vues d'une vidéo
CREATE OR REPLACE FUNCTION increment_video_views(video_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE videos 
  SET views = COALESCE(views, 0) + 1,
      updated_at = NOW()
  WHERE id = video_id;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour incrémenter les likes d'une vidéo
CREATE OR REPLACE FUNCTION increment_video_likes(video_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE videos 
  SET likes = COALESCE(likes, 0) + 1,
      updated_at = NOW()
  WHERE id = video_id;
END;
$$ LANGUAGE plpgsql;

-- Insérer quelques vidéos d'exemple
INSERT INTO videos (title, description, category, duration, views, likes, video_url, thumbnail, created_at) VALUES
('Pasta Carbonara Authentique', 'Apprenez à faire une vraie carbonara italienne avec seulement 5 ingrédients !', 'Plats principaux', 180, 15420, 892, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg', NOW() - INTERVAL '2 days'),
('Technique de découpe des légumes', 'Maîtrisez les techniques de découpe comme un chef professionnel', 'Techniques', 240, 8930, 567, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg', NOW() - INTERVAL '1 day'),
('Tiramisu Express', 'Un tiramisu délicieux en seulement 15 minutes !', 'Desserts', 120, 23450, 1234, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg', NOW() - INTERVAL '12 hours'),
('Smoothie Bowl Tropical', 'Un petit-déjeuner coloré et nutritif pour bien commencer la journée', 'Petit-déjeuner', 90, 12340, 678, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4', 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg', NOW() - INTERVAL '6 hours'),
('Ratatouille Traditionnelle', 'La recette authentique de la ratatouille provençale', 'Plats principaux', 300, 18760, 945, 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4', 'https://images.pexels.com/photos/8629141/pexels-photo-8629141.jpeg', NOW() - INTERVAL '3 hours');