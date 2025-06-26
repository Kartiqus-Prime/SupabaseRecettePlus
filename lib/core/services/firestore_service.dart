import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Créer un profil utilisateur
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String fullName,
    String? phoneNumber,
    String? photoURL,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'photoURL': photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'favorites': [],
        'history': [],
      });
      print('Profil utilisateur créé avec succès');
    } catch (e) {
      print('Erreur lors de la création du profil: $e');
      rethrow;
    }
  }

  // Récupérer le profil utilisateur
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération du profil: $e');
      return null;
    }
  }

  // Mettre à jour le profil utilisateur
  Future<void> updateUserProfile({
    required String uid,
    String? fullName,
    String? phoneNumber,
    String? photoURL,
    int? age,
    String? bio,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (fullName != null) updateData['fullName'] = fullName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (photoURL != null) updateData['photoURL'] = photoURL;
      if (age != null) updateData['age'] = age;
      if (bio != null) updateData['bio'] = bio;

      await _firestore.collection('users').doc(uid).update(updateData);
      print('Profil utilisateur mis à jour avec succès');
    } catch (e) {
      print('Erreur lors de la mise à jour du profil: $e');
      rethrow;
    }
  }

  // Récupérer les favoris de l'utilisateur
  Future<List<Map<String, dynamic>>> getUserFavorites() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return [];

      final userData = userDoc.data()!;
      final favoriteIds = List<String>.from(userData['favorites'] ?? []);

      if (favoriteIds.isEmpty) return [];

      // Récupérer les détails des recettes favorites
      final favorites = <Map<String, dynamic>>[];
      for (final id in favoriteIds) {
        final recipeDoc = await _firestore.collection('recipes').doc(id).get();
        if (recipeDoc.exists) {
          final data = recipeDoc.data()!;
          data['id'] = recipeDoc.id;
          favorites.add(data);
        }
      }

      return favorites;
    } catch (e) {
      print('Erreur lors de la récupération des favoris: $e');
      return [];
    }
  }

  // Récupérer l'historique de l'utilisateur
  Future<List<Map<String, dynamic>>> getUserHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return [];

      final userData = userDoc.data()!;
      final historyIds = List<String>.from(userData['history'] ?? []);

      if (historyIds.isEmpty) return [];

      // Récupérer les détails des recettes de l'historique
      final history = <Map<String, dynamic>>[];
      for (final id in historyIds) {
        final recipeDoc = await _firestore.collection('recipes').doc(id).get();
        if (recipeDoc.exists) {
          final data = recipeDoc.data()!;
          data['id'] = recipeDoc.id;
          history.add(data);
        }
      }

      return history;
    } catch (e) {
      print('Erreur lors de la récupération de l\'historique: $e');
      return [];
    }
  }

  // Ajouter une recette aux favoris
  Future<void> addToFavorites(String recipeId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'favorites': FieldValue.arrayUnion([recipeId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Recette ajoutée aux favoris');
    } catch (e) {
      print('Erreur lors de l\'ajout aux favoris: $e');
      rethrow;
    }
  }

  // Supprimer une recette des favoris
  Future<void> removeFromFavorites(String recipeId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'favorites': FieldValue.arrayRemove([recipeId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Recette supprimée des favoris');
    } catch (e) {
      print('Erreur lors de la suppression des favoris: $e');
      rethrow;
    }
  }

  // Ajouter une recette à l'historique
  Future<void> addToHistory(String recipeId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'history': FieldValue.arrayUnion([recipeId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Recette ajoutée à l\'historique');
    } catch (e) {
      print('Erreur lors de l\'ajout à l\'historique: $e');
      rethrow;
    }
  }

  // Vérifier si une recette est dans les favoris
  Future<bool> isFavorite(String recipeId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data()!;
      final favorites = List<String>.from(userData['favorites'] ?? []);
      return favorites.contains(recipeId);
    } catch (e) {
      print('Erreur lors de la vérification des favoris: $e');
      return false;
    }
  }
}
