class SupabaseOptions {
  static const String url = 'https://your-project-ref.supabase.co';
  static const String anonKey = 'your-anon-key';
  
  // Configuration pour l'authentification
  static const String redirectUrl = 'io.supabase.recetteplus://login-callback/';
  
  // Configuration pour le stockage
  static const String storageBucket = 'recette-plus-storage';
  
  // Tables de la base de données
  static const String usersTable = 'users';
  static const String recipesTable = 'recipes';
  static const String productsTable = 'products';
  static const String favoritesTable = 'favorites';
  static const String historyTable = 'history';
  static const String ordersTable = 'orders';
  static const String videosTable = 'videos';
  static const String cartItemsTable = 'cart_items';
}
