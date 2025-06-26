import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection des utilisateurs
  static const String _usersCollection = 'users';
  static const String _recipesCollection = 'recipes';
  static const String _favoritesCollection = 'favorites';

  // Créer un profil utilisateur
  static Future<void> createUserProfile({
    required String uid,
    required String email,
    required String displayName,
    String? phoneNumber,
  }) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).set({
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isEmailVerified': false,
        'profileImageUrl': null,
      });
    } catch (e) {
      throw Exception('Erreur lors de la création du profil: $e');
    }
  }

  // Mettre à jour le profil utilisateur
  static Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) {
        updateData['displayName'] = displayName;
      }

      if (phoneNumber != null) {
        updateData['phoneNumber'] = phoneNumber;
      }

      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      await _firestore.collection(_usersCollection).doc(uid).update(updateData);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du profil: $e');
    }
  }

  // Récupérer le profil utilisateur
  static Future<Map<String, dynamic>?> getUserProfile([String? uid]) async {
    try {
      final String userId = uid ?? _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) return null;

      final DocumentSnapshot doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du profil: $e');
    }
  }

  // Vérifier si un utilisateur existe
  static Future<bool> userExists(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Supprimer le profil utilisateur
  static Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du profil: $e');
    }
  }

  // Mettre à jour le statut de vérification de l'email
  static Future<void> updateEmailVerificationStatus(String uid, bool isVerified) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).update({
        'isEmailVerified': isVerified,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du statut de vérification: $e');
    }
  }

  // Ajouter une recette aux favoris
  static Future<void> addToFavorites(String recipeId) async {
    try {
      final String? uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception('Utilisateur non connecté');

      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .collection(_favoritesCollection)
          .doc(recipeId)
          .set({
        'recipeId': recipeId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout aux favoris: $e');
    }
  }

  // Supprimer une recette des favoris
  static Future<void> removeFromFavorites(String recipeId) async {
    try {
      final String? uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception('Utilisateur non connecté');

      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .collection(_favoritesCollection)
          .doc(recipeId)
          .delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression des favoris: $e');
    }
  }

  // Vérifier si une recette est dans les favoris
  static Future<bool> isFavorite(String recipeId) async {
    try {
      final String? uid = _auth.currentUser?.uid;
      if (uid == null) return false;

      final DocumentSnapshot doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .collection(_favoritesCollection)
          .doc(recipeId)
          .get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Récupérer les recettes favorites
  static Future<List<String>> getFavoriteRecipeIds() async {
    try {
      final String? uid = _auth.currentUser?.uid;
      if (uid == null) return [];

      final QuerySnapshot snapshot = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .collection(_favoritesCollection)
          .orderBy('addedAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc['recipeId'] as String).toList();
    } catch (e) {
      return [];
    }
  }
}
