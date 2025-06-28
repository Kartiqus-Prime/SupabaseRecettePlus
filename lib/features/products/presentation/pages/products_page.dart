import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/cart_service.dart';
import '../../../../core/utils/currency_utils.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<String> _categories = [
    'Tous',
    'Épices',
    'Huiles',
    'Ustensiles',
    'Électroménager',
    'Livres',
    'Bio',
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
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await SupabaseService.getProducts(
        category: _selectedCategory == 'Tous' ? null : _selectedCategory,
        searchQuery: _searchController.text.trim().isNotEmpty 
            ? _searchController.text.trim() 
            : null,
      );

      // Si aucun produit en base, utiliser des données d'exemple
      if (products.isEmpty && _selectedCategory == 'Tous' && _searchController.text.isEmpty) {
        _products = _getSampleProducts();
      } else {
        _products = products;
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
          _products = _getSampleProducts();
          _isLoading = false;
        });
        _animationController.forward();
      }
    }
  }

  List<Map<String, dynamic>> _getSampleProducts() {
    return [
      {
        'id': '1',
        'name': 'Huile d\'olive extra vierge',
        'category': 'Huiles',
        'price': 4250.0, // Prix en FCFA
        'rating': 4.8,
        'image': 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg',
        'description': 'Huile d\'olive premium de première pression à froid, parfaite pour vos salades et cuissons douces',
        'in_stock': true,
        'unit': 'bouteille 500ml',
      },
      {
        'id': '2',
        'name': 'Set d\'épices du monde',
        'category': 'Épices',
        'price': 16400.0, // Prix en FCFA
        'rating': 4.6,
        'image': 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg',
        'description': 'Collection de 12 épices exotiques pour voyager à travers les saveurs du monde',
        'in_stock': true,
        'unit': 'coffret',
      },
      {
        'id': '3',
        'name': 'Couteau de chef professionnel',
        'category': 'Ustensiles',
        'price': 59000.0, // Prix en FCFA
        'rating': 4.9,
        'image': 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg',
        'description': 'Couteau en acier inoxydable de haute qualité, lame de 20cm, parfait pour tous vos découpages',
        'in_stock': false,
        'unit': 'pièce',
      },
      {
        'id': '4',
        'name': 'Mixeur haute performance',
        'category': 'Électroménager',
        'price': 131000.0, // Prix en FCFA
        'rating': 4.7,
        'image': 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg',
        'description': 'Mixeur puissant 1200W pour smoothies, soupes et préparations diverses',
        'in_stock': true,
        'unit': 'appareil',
      },
      {
        'id': '5',
        'name': 'Livre "Cuisine du monde"',
        'category': 'Livres',
        'price': 19700.0, // Prix en FCFA
        'rating': 4.5,
        'image': 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg',
        'description': '200 recettes traditionnelles du monde entier avec photos et techniques détaillées',
        'in_stock': true,
        'unit': 'livre',
      },
      {
        'id': '6',
        'name': 'Miel bio de lavande',
        'category': 'Bio',
        'price': 10500.0, // Prix en FCFA
        'rating': 4.8,
        'image': 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg',
        'description': 'Miel artisanal bio récolté en Provence, saveur délicate de lavande',
        'in_stock': true,
        'unit': 'pot 250g',
      },
      {
        'id': '7',
        'name': 'Planche à découper bambou',
        'category': 'Ustensiles',
        'price': 8200.0, // Prix en FCFA
        'rating': 4.4,
        'image': 'https://images.pexels.com/photos/4198021/pexels-photo-4198021.jpeg',
        'description': 'Planche à découper écologique en bambou, antibactérienne et durable',
        'in_stock': true,
        'unit': 'pièce',
      },
      {
        'id': '8',
        'name': 'Moulin à poivre électrique',
        'category': 'Ustensiles',
        'price': 24600.0, // Prix en FCFA
        'rating': 4.3,
        'image': 'https://images.pexels.com/photos/4198022/pexels-photo-4198022.jpeg',
        'description': 'Moulin électrique avec éclairage LED, réglage de la finesse de mouture',
        'in_stock': true,
        'unit': 'pièce',
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredProducts {
    if (_searchController.text.isEmpty && _selectedCategory == 'Tous') {
      return _products;
    }

    return _products.where((product) {
      final matchesCategory = _selectedCategory == 'Tous' || 
                             product['category'] == _selectedCategory;
      final matchesSearch = _searchController.text.isEmpty ||
                           product['name']
                               .toLowerCase()
                               .contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    try {
      await CartService.addToCart(
        productId: product['id'],
        quantity: 1,
      );
      
      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product['name']} ajouté au panier'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Voir panier',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Naviguer vers le panier
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

  void _viewProduct(Map<String, dynamic> product) {
    HapticFeedback.mediumImpact();
    
    // TODO: Naviguer vers la page de détail du produit
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture de: ${product['name']}'),
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
                          'Produits',
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
                          Icons.shopping_bag,
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
                          _loadProducts();
                        }
                      },
                      onSubmitted: (value) => _loadProducts(),
                      style: TextStyle(color: AppColors.getTextPrimary(isDark)),
                      decoration: InputDecoration(
                        hintText: 'Rechercher un produit...',
                        hintStyle: TextStyle(color: AppColors.getTextSecondary(isDark)),
                        prefixIcon: Icon(Icons.search, color: AppColors.getTextSecondary(isDark)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: AppColors.getTextSecondary(isDark)),
                                onPressed: () {
                                  _searchController.clear();
                                  _loadProducts();
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
                        _loadProducts();
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
            
            // Grille des produits
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty
                      ? _buildEmptyState(isDark)
                      : FadeTransition(
                          opacity: _fadeAnimation,
                          child: RefreshIndicator(
                            onRefresh: _loadProducts,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(20),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = _filteredProducts[index];
                                return _buildProductCard(product, isDark);
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
            'Aucun produit trouvé',
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
                _selectedCategory = 'Tous';
              });
              _loadProducts();
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
  
  Widget _buildProductCard(Map<String, dynamic> product, bool isDark) {
    final isInStock = product['in_stock'] ?? true;
    
    return Container(
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
        onTap: () => _viewProduct(product),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: product['image'] != null
                          ? Image.network(
                              product['image'],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.primary.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.shopping_bag,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.primary.withOpacity(0.1),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: AppColors.primary,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  
                  // Badge de disponibilité
                  if (!isInStock)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Rupture',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  
                  // Badge catégorie
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        product['category'] ?? 'Autre',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  // Rating
                  if (product['rating'] != null)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product['rating'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Informations du produit
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(isDark),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    if (product['unit'] != null)
                      Text(
                        product['unit'],
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.getTextSecondary(isDark),
                        ),
                      ),
                    
                    const Spacer(),
                    
                    // Prix et bouton d'ajout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CurrencyUtils.formatPrice(product['price']?.toDouble() ?? 0.0),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Bouton d'ajout au panier
                        GestureDetector(
                          onTap: isInStock ? () => _addToCart(product) : null,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isInStock 
                                  ? AppColors.primary 
                                  : AppColors.getTextSecondary(isDark),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isInStock ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ] : null,
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}