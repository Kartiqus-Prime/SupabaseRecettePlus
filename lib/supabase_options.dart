class SupabaseOptions {
  // Configuration depuis les variables d'environnement
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String supabaseServiceRoleKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY');
  
  // Table names basées sur votre structure db.json
  static const String usersTable = 'profiles';
  static const String recipesTable = 'recipes';
  static const String productsTable = 'products';
  static const String favoritesTable = 'favorites';
  static const String historyTable = 'user_history'; // À créer si nécessaire
  static const String ordersTable = 'orders'; // À créer si nécessaire
  static const String videosTable = 'videos';
  static const String cartItemsTable = 'cart_items';
  static const String recipeCartsTable = 'recipe_carts';
  static const String preconfiguredCartsTable = 'preconfigured_carts';
  static const String userCartsTable = 'user_carts';
  static const String userCartItemsTable = 'user_cart_items';
  static const String personalCartsTable = 'personal_carts';
  static const String personalCartItemsTable = 'personal_cart_items';
  static const String recipeUserCartsTable = 'recipe_user_carts';
  static const String recipeCartItemsTable = 'recipe_cart_items';
  static const String userPreconfiguredCartsTable = 'user_preconfigured_carts';
  
  // Tables d'administration
  static const String adminPermissionsTable = 'admin_permissions';
  static const String manageableProductCategoriesTable = 'manageable_product_categories';
  static const String manageableRecipeCategoriesTable = 'manageable_recipe_categories';
  static const String teamMembersTable = 'team_members';
  static const String newsletterCampaignsTable = 'newsletter_campaigns';
  
  // Categories tables
  static const String productCategoriesTable = 'product_categories';
  static const String recipeCategoriesTable = 'recipe_categories';
  
  // Storage buckets
  static const String avatarsBucket = 'avatars';
  static const String recipeImagesBucket = 'recipe-images';
  static const String productImagesBucket = 'product-images';
  static const String videosBucket = 'videos';
  static const String thumbnailsBucket = 'thumbnails';
}