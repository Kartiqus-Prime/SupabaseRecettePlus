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
      await _client.rpc('increment_video_views', params: {'video_id': videoId});
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur incrémentation vues: $e');
      }
    }
  }

  // Liker une vidéo
  static Future<void> likeVideo(String videoId) async {
    try {
      await _client.rpc('increment_video_likes', params: {'video_id': videoId});
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur like vidéo: $e');
      }
    }
  }
}