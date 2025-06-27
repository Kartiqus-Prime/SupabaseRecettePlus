class SupabaseOptions {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // Table names
  static const String usersTable = 'users';
  static const String recipesTable = 'recipes';
  static const String productsTable = 'products';
  static const String favoritesTable = 'favorites';
  static const String historyTable = 'history';
  static const String ordersTable = 'orders';
  
  // Storage buckets
  static const String avatarsBucket = 'avatars';
  static const String recipeImagesBucket = 'recipe-images';
  static const String productImagesBucket = 'product-images';
}
