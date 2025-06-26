# Guide de Migration Firebase vers Supabase

## Vue d'ensemble

Ce guide détaille la migration complète de votre application Flutter de Firebase vers Supabase. Tous les fichiers Firebase ont été remplacés par leurs équivalents Supabase.

## Changements principaux

### 1. Dépendances (pubspec.yaml)

**Supprimé :**
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`

**Ajouté :**
- `supabase_flutter: ^2.5.6`
- `crypto: ^3.0.3` (pour les hash si nécessaire)

### 2. Configuration

**Fichiers supprimés :**
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `firebaseAdmin.json`

**Fichiers ajoutés :**
- `lib/supabase_options.dart` - Configuration Supabase
- `supabase/migrations/001_initial_schema.sql` - Schéma de base de données
- `supabase/migrations/002_sample_data.sql` - Données d'exemple

### 3. Services

**Remplacé :**
- `lib/core/services/firestore_service.dart` → `lib/core/services/supabase_service.dart`

### 4. Authentification

**Changements dans les pages d'authentification :**
- Remplacement de `FirebaseAuth` par `Supabase.instance.client.auth`
- Mise à jour des méthodes d'authentification
- Gestion des erreurs adaptée à Supabase

## Configuration Supabase requise

### 1. Créer un projet Supabase

1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Notez votre URL et clé anonyme

### 2. Mettre à jour la configuration

Dans `lib/supabase_options.dart`, remplacez :
\`\`\`dart
static const String url = 'https://your-project-ref.supabase.co';
static const String anonKey = 'your-anon-key';
\`\`\`

### 3. Exécuter les migrations

1. Installez Supabase CLI : `npm install -g supabase`
2. Connectez-vous : `supabase login`
3. Liez votre projet : `supabase link --project-ref your-project-ref`
4. Exécutez les migrations : `supabase db push`

### 4. Configurer l'authentification Google

Dans le dashboard Supabase :
1. Allez dans Authentication > Providers
2. Activez Google
3. Ajoutez vos Client ID et Client Secret Google

## Structure de la base de données

### Tables créées :

1. **users** - Profils utilisateurs étendus
2. **recipes** - Recettes avec ingrédients et instructions
3. **products** - Produits de la boutique
4. **favorites** - Recettes favorites des utilisateurs
5. **history** - Historique de consultation
6. **videos** - Vidéos de recettes
7. **cart_items** - Panier d'achat
8. **orders** - Commandes

### Sécurité (RLS)

Toutes les tables ont des politiques de sécurité Row Level Security (RLS) configurées pour :
- Permettre aux utilisateurs de gérer leurs propres données
- Autoriser la lecture publique des contenus actifs
- Protéger les données sensibles

## Fonctionnalités migrées

### ✅ Authentification
- Connexion email/mot de passe
- Inscription
- Connexion Google
- Réinitialisation de mot de passe
- Gestion des sessions

### ✅ Gestion des profils
- Création automatique du profil
- Mise à jour des informations
- Gestion des métadonnées

### ✅ Favoris
- Ajout/suppression de favoris
- Liste des favoris avec jointures
- Vérification du statut favori

### ✅ Historique
- Suivi des recettes consultées
- Historique ordonné par date

### ✅ Base de données
- Requêtes optimisées avec index
- Jointures pour les relations
- Filtrage et recherche

## Fonctionnalités à implémenter

### 🔄 Stockage de fichiers
Le service inclut des méthodes pour :
- Upload de fichiers (`uploadFile`)
- Suppression de fichiers (`deleteFile`)
- Génération d'URLs publiques

### 🔄 Temps réel
Supabase offre des capacités temps réel natives :
\`\`\`dart
// Exemple d'écoute en temps réel
Supabase.instance.client
  .from('recipes')
  .stream(primaryKey: ['id'])
  .listen((data) {
    // Mise à jour automatique
  });
\`\`\`

## Avantages de la migration

1. **Performance** - Base de données PostgreSQL plus rapide
2. **Coût** - Tarification plus avantageuse que Firebase
3. **Flexibilité** - SQL complet disponible
4. **Temps réel** - Fonctionnalités temps réel intégrées
5. **Sécurité** - RLS au niveau base de données
6. **Open Source** - Solution open source

## Prochaines étapes

1. Configurez votre projet Supabase
2. Exécutez les migrations
3. Mettez à jour les clés dans `supabase_options.dart`
4. Testez l'authentification
5. Vérifiez les fonctionnalités de base
6. Implémentez le stockage de fichiers si nécessaire
7. Ajoutez les fonctionnalités temps réel

## Support

Pour toute question sur la migration, consultez :
- [Documentation Supabase](https://supabase.com/docs)
- [Guide de migration Firebase vers Supabase](https://supabase.com/docs/guides/migrations/firebase-auth)
