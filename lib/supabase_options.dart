class SupabaseOptions {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL_HERE',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY_HERE',
  );

  // Table names
  static const String usersTable = 'users';
  static const String recipesTable = 'recipes';
  static const String productsTable = 'products';
  static const String favoritesTable = 'favorites';
  static const String historyTable = 'history';
  static const String ordersTable = 'orders';
  static const String categoriesTable = 'categories';
  static const String videosTable = 'videos';

  // Storage buckets
  static const String recipeImagesBucket = 'recipe-images';
  static const String productImagesBucket = 'product-images';
  static const String userAvatarsBucket = 'user-avatars';
}
