import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/cart_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  
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
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _products = _getSampleProducts();
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _getSampleProducts() {
    return [
      {
        'id': '1',
        'name': 'Huile d\'olive extra vierge',
        'category': 'Huiles',
        'price': 12.99,
        'rating': 4.8,
        'image': 'https://images.pexels.com/photos/33783/olive-oil-salad-dressing-cooking-olive.jpg',
        'description': 'Huile d\'olive premium de première pression à froid',
        'in_stock': true,
      },
      {
        'id': '2',
        'name': 'Set d\'épices du monde',
        'category': 'Épices',
        'price': 24.99,
        'rating': 4.6,
        'image': 'https://images.pexels.com/photos/1340116/pexels-photo-1340116.jpeg',
        'description': 'Collection de 12 épices exotiques',
        'in_stock': true,
      },
      {
        'id': '3',
        'name': 'Couteau de chef professionnel',
        'category': 'Ustensiles',
        'price': 89.99,
        'rating': 4.9,
        'image': 'https://images.pexels.com/photos/2284166/pexels-photo-2284166.jpeg',
        'description': 'Couteau en acier inoxydable de haute qualité',
        'in_stock': false,
      },
      {
        'id': '4',
        'name': 'Mixeur haute performance',
        'category': 'Électroménager',
        'price': 199.99,
        'rating': 4.7,
        'image': 'https://images.pexels.com/photos/4226796/pexels-photo-4226796.jpeg',
        'description': 'Mixeur puissant pour smoothies et soupes',
        'in_stock': true,
      },
      {
        'id': '5',
        'name': 'Livre "Cuisine du monde"',
        'category': 'Livres',
        'price': 29.99,
        'rating': 4.5,
        'image': 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg',
        'description': '200 recettes traditionnelles du monde entier',
        'in_stock': true,
      },
      {
        'id': '6',
        'name': 'Miel bio de lavande',
        'category': 'Bio',
        'price': 15.99,
        'rating': 4.8,
        'image': 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg',
        'description': 'Miel artisanal bio récolté en Provence',
        'in_stock': true,
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

  String _formatPrice(double price) {
    // Conversion EUR vers FCFA (1 EUR ≈ 655.957 FCFA)
    final priceInFCFA = price * 655.957;
    return '${priceInFCFA.toStringAsFixed(0)} FCFA';
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    try {
      await CartService.addToCart(
        productId: product['id'],
        quantity: 1,
      );
      
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec recherche
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Produits',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Barre de recherche
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
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
                      decoration: const InputDecoration(
                        hintText: 'Rechercher un produit...',
                        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Filtres par catégorie
            Container(
              height: 60,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  
                  return Container(
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _loadProducts();
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                      ),
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
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Aucun produit trouvé',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadProducts,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(20),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return _buildProductCard(product);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProductCard(Map<String, dynamic> product) {
    final isInStock = product['in_stock'] ?? true;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ouverture de ${product['name']}')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                                    size: 32,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.primary.withOpacity(0.1),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            ),
                    ),
                    // Badge de disponibilité
                    if (!isInStock)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
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
                  ],
                ),
              ),
            ),
            
            // Informations du produit
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['description'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatPrice(product['price']?.toDouble() ?? 0.0),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            if (product['rating'] != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    product['rating'].toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                          ],
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
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add_shopping_cart,
                              color: isInStock ? Colors.white : Colors.grey[600],
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