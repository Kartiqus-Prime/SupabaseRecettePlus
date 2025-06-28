import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Toutes';
  List<Map<String, dynamic>> _recipes = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<String> _categories = [
    'Toutes',
    'Entrées',
    'Plats principaux',
    'Desserts',
    'Boissons',
    'Végétarien',
    'Rapide',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recipes = await SupabaseService.getRecipes(
        category: _selectedCategory == 'Toutes' ? null : _selectedCategory,
        searchQuery: _searchController.text.trim().isNotEmpty 
            ? _searchController.text.trim() 
            : null,
      );

      // Si aucune recette en base, utiliser des données d'exemple
      if (recipes.isEmpty && _selectedCategory == 'Toutes' && _searchController.text.isEmpty) {
        _recipes = _getSampleRecipes();
      } else {
        _recipes = recipes;
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recipes = _getSampleRecipes();
          _isLoading = false;
        });
        _animationController.forward();
      }
    }
  }

  List<Map<String, dynamic>> _getSampleRecipes() {
    return [
      {
        'id': '1',
        'title': 'Pasta Carbonara Authentique',
        'category': 'Plats principaux',
        'cook_time': 20,
        'servings': 4,
        'difficulty': 'Facile',
        'rating': 4.8,
        'image': 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg',
        'description': 'Un classique italien crémeux et délicieux avec seulement 5 ingrédients',
        'ingredients': ['400g de spaghetti', '200g de pancetta', '4 œufs', '100g de parmesan', 'Poivre noir'],
        'instructions': ['Faire cuire les pâtes', 'Faire revenir la pancetta', 'Mélanger œufs et parmesan', 'Combiner le tout'],
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Salade César Parfaite',
        'category': 'Entrées',
        'cook_time': 15,
        'servings': 2,
        'difficulty': 'Facile',
        'rating': 4.5,
        'image': 'https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg',
        'description': 'Salade fraîche avec croûtons croustillants et parmesan',
        'ingredients': ['Laitue romaine', 'Croûtons', 'Parmesan', 'Sauce césar', 'Anchois'],
        'instructions': ['Laver la salade', 'Préparer les croûtons', 'Mélanger avec la sauce'],
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': '3',
        'title': 'Tiramisu Express',
        'category': 'Desserts',
        'cook_time': 30,
        'servings': 6,
        'difficulty': 'Moyen',
        'rating': 4.9,
        'image': 'https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg',
        'description': 'Dessert italien au café et mascarpone, version rapide',
        'ingredients': ['Mascarpone', 'Œufs', 'Sucre', 'Café', 'Biscuits à la cuillère', 'Cacao'],
        'instructions': ['Préparer la crème', 'Tremper les biscuits', 'Monter en couches', 'Réfrigérer'],
        'created_at': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
      },
      {
        'id': '4',
        'title': 'Smoothie Bowl Tropical',
        'category': 'Boissons',
        'cook_time': 5,
        'servings': 1,
        'difficulty': 'Facile',
        'rating': 4.3,
        'image': 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg',
        'description': 'Boisson rafraîchissante aux fruits exotiques',
        'ingredients': ['Mangue', 'Ananas', 'Banane', 'Lait de coco', 'Granola'],
        'instructions': ['Mixer les fruits', 'Verser dans un bol', 'Ajouter les toppings'],
        'created_at': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      },
      {
        'id': '5',
        'title': 'Buddha Bowl Nutritif',
        'category': 'Végétarien',
        'cook_time': 25,
        'servings': 2,
        'difficulty': 'Facile',
        'rating': 4.6,
        'image': 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
        'description': 'Bol nutritif avec légumes colorés et quinoa',
        'ingredients': ['Quinoa', 'Avocat', 'Légumes variés', 'Graines', 'Sauce tahini'],
        'instructions': ['Cuire le quinoa', 'Préparer les légumes', 'Assembler le bol'],
        'created_at': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      },
      {
        'id': '6',
        'title': 'Omelette Express',
        'category': 'Rapide',
        'cook_time': 8,
        'servings': 1,
        'difficulty': 'Facile',
        'rating': 4.2,
        'image': 'https://images.pexels.com/photos/824635/pexels-photo-824635.jpeg',
        'description': 'Petit-déjeuner rapide et protéiné',
        'ingredients': ['3 œufs', 'Beurre', 'Herbes fraîches', 'Fromage', 'Sel et poivre'],
        'instructions': ['Battre les œufs', 'Chauffer la poêle', 'Cuire l\'omelette'],
        'created_at': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredRecipes {
    if (_searchController.text.isEmpty && _selectedCategory == 'Toutes') {
      return _recipes;
    }

    return _recipes.where((recipe) {
      final matchesCategory = _selectedCategory == 'Toutes' || 
                             recipe['category'] == _selectedCategory;
      final matchesSearch = _searchController.text.isEmpty ||
                           recipe['title']
                               .toLowerCase()
                               .contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _addToFavorites(Map<String, dynamic> recipe) async {
    try {
      await SupabaseService.addToFavorites(recipe['id'], 'recipe');
      
      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${recipe['title']} ajouté aux favoris'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Voir favoris',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Naviguer vers les favoris
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _viewRecipe(Map<String, dynamic> recipe) {
    HapticFeedback.mediumImpact();
    
    // Ajouter à l'historique
    SupabaseService.addToHistory(recipe['id']);
    
    // TODO: Naviguer vers la page de détail de la recette
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture de: ${recipe['title']}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: AppColors.getBackground(isDark),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec recherche
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.getSurface(isDark),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.getShadow(isDark),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Recettes',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(isDark),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Barre de recherche
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.getBackground(isDark),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.getBorder(isDark),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                        if (value.isEmpty) {
                          _loadRecipes();
                        }
                      },
                      onSubmitted: (value) => _loadRecipes(),
                      style: TextStyle(color: AppColors.getTextPrimary(isDark)),
                      decoration: InputDecoration(
                        hintText: 'Rechercher une recette...',
                        hintStyle: TextStyle(color: AppColors.getTextSecondary(isDark)),
                        prefixIcon: Icon(Icons.search, color: AppColors.getTextSecondary(isDark)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: AppColors.getTextSecondary(isDark)),
                                onPressed: () {
                                  _searchController.clear();
                                  _loadRecipes();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Filtres par catégorie
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.getSurface(isDark),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.getBorder(isDark),
                    width: 1,
                  ),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _loadRecipes();
                      },
                      backgroundColor: AppColors.getBackground(isDark),
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.getTextSecondary(isDark),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.getBorder(isDark),
                        width: isSelected ? 2 : 1,
                      ),
                      elevation: isSelected ? 2 : 0,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                  );
                },
              ),
            ),
            
            // Liste des recettes
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredRecipes.isEmpty
                      ? _buildEmptyState(isDark)
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: RefreshIndicator(
                            onRefresh: _loadRecipes,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: _filteredRecipes.length,
                              itemBuilder: (context, index) {
                                final recipe = _filteredRecipes[index];
                                return _buildRecipeCard(recipe, isDark);
                              },
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 60,
              color: AppColors.primary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune recette trouvée',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(isDark),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez de modifier vos critères de recherche',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getTextSecondary(isDark),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _selectedCategory = 'Toutes';
              });
              _loadRecipes();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Réinitialiser les filtres'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecipeCard(Map<String, dynamic> recipe, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDark),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadow(isDark),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _viewRecipe(recipe),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de la recette
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: recipe['image'] != null
                        ? Image.network(
                            recipe['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: AppColors.primary,
                                  size: 60,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Icon(
                              Icons.restaurant,
                              color: AppColors.primary,
                              size: 60,
                            ),
                          ),
                  ),
                ),
                
                // Overlay gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Badge catégorie
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      recipe['category'] ?? 'Autre',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                // Bouton favori
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => _addToFavorites(recipe),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                
                // Rating
                if (recipe['rating'] != null)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            recipe['rating'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            
            // Informations de la recette
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['title'] ?? 'Recette sans titre',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(isDark),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  if (recipe['description'] != null)
                    Text(
                      recipe['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.getTextSecondary(isDark),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Informations détaillées
                  Row(
                    children: [
                      if (recipe['cook_time'] != null)
                        _buildInfoChip(
                          Icons.access_time,
                          '${recipe['cook_time']} min',
                          isDark,
                        ),
                      const SizedBox(width: 8),
                      if (recipe['servings'] != null)
                        _buildInfoChip(
                          Icons.people,
                          '${recipe['servings']} pers.',
                          isDark,
                        ),
                      const SizedBox(width: 8),
                      if (recipe['difficulty'] != null)
                        _buildInfoChip(
                          Icons.bar_chart,
                          recipe['difficulty'],
                          isDark,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoChip(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.getBackground(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.getBorder(isDark),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.getTextSecondary(isDark),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.getTextSecondary(isDark),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}