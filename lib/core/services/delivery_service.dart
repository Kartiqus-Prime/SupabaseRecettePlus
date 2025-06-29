import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class DeliveryService {
  static final SupabaseClient _client = Supabase.instance.client;
  static StreamSubscription<Position>? _locationSubscription;

  // ==================== GESTION DES COMMANDES ====================

  /// Obtenir les commandes disponibles pour un livreur
  static Future<List<Map<String, dynamic>>> getAvailableOrders() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      // Récupérer l'ID du personnel de livraison
      final personnelResponse = await _client
          .from('delivery_personnel')
          .select('id')
          .eq('user_id', userId)
          .single();

      final personnelId = personnelResponse['id'];

      // Utiliser la fonction SQL pour obtenir les commandes disponibles
      final response = await _client
          .rpc('get_available_orders_for_delivery', params: {
        'personnel_uuid': personnelId,
      });

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération commandes disponibles: $e');
      }
      return [];
    }
  }

  /// Scanner un code QR pour prendre une commande
  static Future<Map<String, dynamic>> scanQRCode(String qrCode) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      // Récupérer l'ID du personnel de livraison
      final personnelResponse = await _client
          .from('delivery_personnel')
          .select('id')
          .eq('user_id', userId)
          .single();

      final personnelId = personnelResponse['id'];

      // Utiliser la fonction SQL pour scanner le QR code
      final response = await _client
          .rpc('scan_qr_code', params: {
        'qr_code_value': qrCode,
        'personnel_uuid': personnelId,
      });

      return Map<String, dynamic>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur scan QR code: $e');
      }
      return {
        'success': false,
        'message': 'Erreur lors du scan: $e',
      };
    }
  }

  /// Mettre à jour le statut d'une commande
  static Future<bool> updateOrderStatus({
    required String orderId,
    required String newStatus,
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      // Récupérer le rôle de l'utilisateur
      final profileResponse = await _client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();

      final userRole = profileResponse['role'] ?? 'user';

      // Utiliser la fonction SQL pour mettre à jour le statut
      await _client.rpc('update_order_status', params: {
        'order_uuid': orderId,
        'new_status_val': newStatus,
        'user_uuid': userId,
        'user_role_val': userRole,
        'notes_val': notes,
        'latitude': latitude,
        'longitude': longitude,
      });

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur mise à jour statut commande: $e');
      }
      return false;
    }
  }

  // ==================== GESTION DE LA GÉOLOCALISATION ====================

  /// Démarrer le suivi de position pour un livreur
  static Future<bool> startLocationTracking(String orderId) async {
    try {
      // Vérifier les permissions de géolocalisation
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permission de géolocalisation refusée');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permission de géolocalisation refusée définitivement');
      }

      // Démarrer le suivi de position
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Mettre à jour tous les 10 mètres
      );

      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        _updateDeliveryLocation(
          orderId: orderId,
          latitude: position.latitude,
          longitude: position.longitude,
          speed: position.speed,
          heading: position.heading,
          accuracy: position.accuracy,
        );
      });

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur démarrage suivi position: $e');
      }
      return false;
    }
  }

  /// Arrêter le suivi de position
  static void stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  /// Mettre à jour la position du livreur
  static Future<void> _updateDeliveryLocation({
    required String orderId,
    required double latitude,
    required double longitude,
    double? speed,
    double? heading,
    double? accuracy,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      // Récupérer l'ID du personnel de livraison
      final personnelResponse = await _client
          .from('delivery_personnel')
          .select('id')
          .eq('user_id', userId)
          .single();

      final personnelId = personnelResponse['id'];

      // Utiliser la fonction SQL pour mettre à jour la position
      await _client.rpc('update_delivery_location', params: {
        'personnel_uuid': personnelId,
        'order_uuid': orderId,
        'latitude': latitude,
        'longitude': longitude,
        'speed_val': speed,
        'heading_val': heading,
        'accuracy_val': accuracy,
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur mise à jour position: $e');
      }
    }
  }

  /// Obtenir la position actuelle du livreur pour une commande
  static Future<Map<String, dynamic>?> getCurrentDeliveryLocation(String orderId) async {
    try {
      final response = await _client
          .from('order_tracking')
          .select('''
            current_location,
            estimated_arrival,
            distance_remaining,
            updated_at,
            delivery_personnel:delivery_personnel_id (
              full_name,
              phone_number,
              vehicle_type,
              rating
            )
          ''')
          .eq('order_id', orderId)
          .single();

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération position livraison: $e');
      }
      return null;
    }
  }

  // ==================== GESTION DU PERSONNEL DE LIVRAISON ====================

  /// Obtenir les informations du personnel de livraison connecté
  static Future<Map<String, dynamic>?> getDeliveryPersonnelInfo() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _client
          .from('delivery_personnel')
          .select()
          .eq('user_id', userId)
          .single();

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération info personnel: $e');
      }
      return null;
    }
  }

  /// Mettre à jour le statut du livreur
  static Future<bool> updateDeliveryPersonnelStatus(String status) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      await _client
          .from('delivery_personnel')
          .update({'status': status})
          .eq('user_id', userId);

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur mise à jour statut personnel: $e');
      }
      return false;
    }
  }

  /// Obtenir les commandes assignées au livreur
  static Future<List<Map<String, dynamic>>> getAssignedOrders() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      // Récupérer l'ID du personnel de livraison
      final personnelResponse = await _client
          .from('delivery_personnel')
          .select('id')
          .eq('user_id', userId)
          .single();

      final personnelId = personnelResponse['id'];

      // Récupérer les commandes assignées
      final response = await _client
          .from('orders')
          .select('''
            id,
            total_amount,
            delivery_address,
            delivery_notes,
            status,
            estimated_delivery_time,
            created_at,
            items
          ''')
          .eq('delivery_personnel_id', personnelId)
          .in_('status', ['picked_up', 'in_transit'])
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération commandes assignées: $e');
      }
      return [];
    }
  }

  // ==================== SUIVI POUR LES CLIENTS ====================

  /// Obtenir le suivi d'une commande pour un client
  static Future<Map<String, dynamic>?> getOrderTracking(String orderId) async {
    try {
      final response = await _client
          .from('orders')
          .select('''
            id,
            status,
            delivery_address,
            estimated_delivery_time,
            updated_at,
            delivery_personnel:delivery_personnel_id (
              full_name,
              phone_number,
              vehicle_type,
              rating,
              current_location
            ),
            order_tracking!inner (
              current_location,
              estimated_arrival,
              distance_remaining,
              updated_at
            ),
            order_status_history (
              old_status,
              new_status,
              notes,
              created_at
            )
          ''')
          .eq('id', orderId)
          .single();

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération suivi commande: $e');
      }
      return null;
    }
  }

  /// Obtenir l'historique des positions pour une commande
  static Future<List<Map<String, dynamic>>> getDeliveryLocationHistory(String orderId) async {
    try {
      final response = await _client
          .from('delivery_locations')
          .select('location, speed, heading, created_at')
          .eq('order_id', orderId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération historique positions: $e');
      }
      return [];
    }
  }

  // ==================== UTILITAIRES ====================

  /// Calculer la distance entre deux points
  static Future<double> calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) async {
    try {
      final response = await _client.rpc('calculate_distance', params: {
        'lat1': lat1,
        'lon1': lon1,
        'lat2': lat2,
        'lon2': lon2,
      });

      return (response as num).toDouble();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur calcul distance: $e');
      }
      return 0.0;
    }
  }

  /// Estimer le temps de livraison
  static Duration estimateDeliveryTime(double distanceKm, {double averageSpeedKmh = 30.0}) {
    final timeInHours = distanceKm / averageSpeedKmh;
    final timeInMinutes = (timeInHours * 60).round();
    return Duration(minutes: timeInMinutes);
  }

  /// Formater le statut de commande pour l'affichage
  static String formatOrderStatus(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmée';
      case 'preparing':
        return 'En préparation';
      case 'ready_for_pickup':
        return 'Prête pour enlèvement';
      case 'picked_up':
        return 'Prise en charge';
      case 'in_transit':
        return 'En cours de livraison';
      case 'delivered':
        return 'Livrée';
      case 'cancelled':
        return 'Annulée';
      case 'returned':
        return 'Retournée';
      default:
        return status;
    }
  }

  /// Obtenir la couleur associée au statut
  static String getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return '#FFA500'; // Orange
      case 'confirmed':
        return '#2196F3'; // Bleu
      case 'preparing':
        return '#FF9800'; // Orange foncé
      case 'ready_for_pickup':
        return '#9C27B0'; // Violet
      case 'picked_up':
        return '#3F51B5'; // Indigo
      case 'in_transit':
        return '#2196F3'; // Bleu
      case 'delivered':
        return '#4CAF50'; // Vert
      case 'cancelled':
        return '#F44336'; // Rouge
      case 'returned':
        return '#795548'; // Marron
      default:
        return '#9E9E9E'; // Gris
    }
  }
}