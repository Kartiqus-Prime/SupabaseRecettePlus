import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../supabase_options.dart';

class VideoService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Obtenir toutes les vidéos
  static Future<List<Map<String, dynamic>>> getVideos({
    String? category,
    int limit = 20,
  }) async {
    try {
      var query = _client.from('videos').select();

      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération vidéos: $e');
      }
      return [];
    }
  }

  // Obtenir une vidéo par ID
  static Future<Map<String, dynamic>?> getVideoById(String videoId) async {
    try {
      final response = await _client
          .from('videos')
          .select()
          .eq('id', videoId)
          .single();

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération vidéo: $e');
      }
      return null;
    }
  }

  // Incrémenter les vues
  static Future<void> incrementViews(String videoId) async {
    try {
      // Utiliser une fonction SQL pour incrémenter atomiquement
      await _client.rpc('increment_video_views', params: {'video_id': videoId});
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur incrémentation vues: $e');
      }
      // Fallback: mise à jour manuelle
      try {
        final video = await getVideoById(videoId);
        if (video != null) {
          final currentViews = video['views'] ?? 0;
          await _client
              .from('videos')
              .update({'views': currentViews + 1})
              .eq('id', videoId);
        }
      } catch (fallbackError) {
        if (kDebugMode) {
          print('❌ Erreur fallback incrémentation vues: $fallbackError');
        }
      }
    }
  }

  // Liker une vidéo
  static Future<void> likeVideo(String videoId) async {
    try {
      // Utiliser une fonction SQL pour incrémenter atomiquement
      await _client.rpc('increment_video_likes', params: {'video_id': videoId});
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur like vidéo: $e');
      }
      // Fallback: mise à jour manuelle
      try {
        final video = await getVideoById(videoId);
        if (video != null) {
          final currentLikes = video['likes'] ?? 0;
          await _client
              .from('videos')
              .update({'likes': currentLikes + 1})
              .eq('id', videoId);
        }
      } catch (fallbackError) {
        if (kDebugMode) {
          print('❌ Erreur fallback like vidéo: $fallbackError');
        }
      }
    }
  }

  // Obtenir les vidéos par catégorie
  static Future<List<Map<String, dynamic>>> getVideosByCategory(String category) async {
    try {
      final response = await _client
          .from('videos')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération vidéos par catégorie: $e');
      }
      return [];
    }
  }

  // Rechercher des vidéos
  static Future<List<Map<String, dynamic>>> searchVideos(String query) async {
    try {
      final response = await _client
          .from('videos')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur recherche vidéos: $e');
      }
      return [];
    }
  }

  // Obtenir les vidéos populaires
  static Future<List<Map<String, dynamic>>> getPopularVideos({int limit = 10}) async {
    try {
      final response = await _client
          .from('videos')
          .select()
          .order('views', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération vidéos populaires: $e');
      }
      return [];
    }
  }

  // Obtenir les vidéos récentes
  static Future<List<Map<String, dynamic>>> getRecentVideos({int limit = 10}) async {
    try {
      final response = await _client
          .from('videos')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération vidéos récentes: $e');
      }
      return [];
    }
  }
}