import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/video_service.dart';
import '../widgets/video_player_widget.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadVideos();
    // Masquer la barre de statut pour une expérience plein écran
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Restaurer la barre de statut
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger des vidéos d'exemple si la base de données n'est pas configurée
      final videos = await VideoService.getVideos(limit: 50);
      
      // Si aucune vidéo en base, utiliser des données d'exemple
      if (videos.isEmpty) {
        _videos = _getSampleVideos();
      } else {
        _videos = videos;
      }
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // En cas d'erreur, utiliser des données d'exemple
      if (mounted) {
        setState(() {
          _videos = _getSampleVideos();
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _getSampleVideos() {
    return [
      {
        'id': '1',
        'title': 'Pasta Carbonara Authentique',
        'description': 'Apprenez à faire une vraie carbonara italienne avec seulement 5 ingrédients !',
        'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        'thumbnail': 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg',
        'duration': 180,
        'views': 15420,
        'likes': 892,
        'category': 'Plats principaux',
        'recipe_id': 'recipe_1',
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Technique de découpe des légumes',
        'description': 'Maîtrisez les techniques de découpe comme un chef professionnel',
        'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
        'thumbnail': 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
        'duration': 240,
        'views': 8930,
        'likes': 567,
        'category': 'Techniques',
        'recipe_id': null,
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': '3',
        'title': 'Tiramisu Express',
        'description': 'Un tiramisu délicieux en seulement 15 minutes !',
        'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        'thumbnail': 'https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg',
        'duration': 120,
        'views': 23450,
        'likes': 1234,
        'category': 'Desserts',
        'recipe_id': 'recipe_3',
        'created_at': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
      },
      {
        'id': '4',
        'title': 'Smoothie Bowl Tropical',
        'description': 'Un petit-déjeuner coloré et nutritif pour bien commencer la journée',
        'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
        'thumbnail': 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg',
        'duration': 90,
        'views': 12340,
        'likes': 678,
        'category': 'Petit-déjeuner',
        'recipe_id': 'recipe_4',
        'created_at': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      },
      {
        'id': '5',
        'title': 'Ratatouille Traditionnelle',
        'description': 'La recette authentique de la ratatouille provençale',
        'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        'thumbnail': 'https://images.pexels.com/photos/8629141/pexels-photo-8629141.jpeg',
        'duration': 300,
        'views': 18760,
        'likes': 945,
        'category': 'Plats principaux',
        'recipe_id': 'recipe_5',
        'created_at': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      },
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Incrémenter les vues de la vidéo
    if (_videos.isNotEmpty && index < _videos.length) {
      final videoId = _videos[index]['id'];
      if (videoId != null) {
        VideoService.incrementViews(videoId);
      }
    }
  }

  Future<void> _likeVideo(String videoId, int currentLikes) async {
    try {
      await VideoService.likeVideo(videoId);
      
      // Mettre à jour localement
      setState(() {
        final videoIndex = _videos.indexWhere((v) => v['id'] == videoId);
        if (videoIndex != -1) {
          _videos[videoIndex]['likes'] = currentLikes + 1;
        }
      });
      
      // Feedback haptique
      HapticFeedback.lightImpact();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  void _shareVideo(Map<String, dynamic> video) {
    // TODO: Implémenter le partage
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage de: ${video['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showRecipe(String? recipeId) {
    if (recipeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune recette associée à cette vidéo'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // TODO: Naviguer vers la page de recette
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture de la recette: $recipeId'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    if (_videos.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.video_library_outlined,
                size: 80,
                color: Colors.white54,
              ),
              const SizedBox(height: 16),
              const Text(
                'Aucune vidéo disponible',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadVideos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // PageView pour le scroll vertical des vidéos
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final video = _videos[index];
              return VideoPlayerWidget(
                video: video,
                isActive: index == _currentIndex,
                onLike: () => _likeVideo(
                  video['id'], 
                  video['likes'] ?? 0,
                ),
                onShare: () => _shareVideo(video),
                onShowRecipe: () => _showRecipe(video['recipe_id']),
              );
            },
          ),
          
          // Indicateur de position (optionnel)
          if (_videos.length > 1)
            Positioned(
              right: 8,
              top: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: List.generate(_videos.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    width: 3,
                    height: index == _currentIndex ? 20 : 8,
                    decoration: BoxDecoration(
                      color: index == _currentIndex 
                          ? Colors.white 
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}