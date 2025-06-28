import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../supabase_options.dart';

class CartService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Obtenir le panier utilisateur
  static Future<Map<String, dynamic>?> getUserCart() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _client
          .from('user_carts')
          .select()
          .eq('user_id', userId)
          .single();

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération panier: $e');
      }
      return null;
    }
  }

  // Créer un panier pour l'utilisateur
  static Future<String?> createUserCart() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _client
          .from('user_carts')
          .insert({
            'user_id': userId,
            'total_price': 0,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return response['id'];
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur création panier: $e');
      }
      return null;
    }
  }

  // Ajouter un item au panier
  static Future<void> addToCart({
    required String productId,
    required int quantity,
    String cartType = 'personal',
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('Utilisateur non connecté');

      // Obtenir ou créer le panier
      var cart = await getUserCart();
      if (cart == null) {
        final cartId = await createUserCart();
        if (cartId == null) throw Exception('Impossible de créer le panier');
      }

      // Ajouter l'item
      await _client.from('user_cart_items').insert({
        'user_cart_id': cart!['id'],
        'cart_reference_id': productId,
        'cart_reference_type': cartType,
        'cart_name': 'Panier personnel',
        'items_count': quantity,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        print('✅ Produit ajouté au panier');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur ajout au panier: $e');
      }
      rethrow;
    }
  }

  // Obtenir les items du panier
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      final cart = await getUserCart();
      if (cart == null) return [];

      final response = await _client
          .from('user_cart_items')
          .select()
          .eq('user_cart_id', cart['id'])
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur récupération items panier: $e');
      }
      return [];
    }
  }

  // Calculer le total du panier
  static Future<double> calculateCartTotal() async {
    try {
      final items = await getCartItems();
      double total = 0.0;

      for (final item in items) {
        final cartTotal = item['cart_total_price'] ?? 0;
        total += (cartTotal is num) ? cartTotal.toDouble() : 0.0;
      }

      return total;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur calcul total panier: $e');
      }
      return 0.0;
    }
  }
}