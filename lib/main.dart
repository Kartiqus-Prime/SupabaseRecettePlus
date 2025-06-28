import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'features/recipes/presentation/pages/recipes_page.dart';
import 'features/products/presentation/pages/products_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/videos/presentation/pages/videos_page.dart';
import 'core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('🚀 Démarrage de l\'application...');
    
    // Configuration Supabase avec des valeurs par défaut pour éviter les erreurs
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://your-project.supabase.co', // Remplacez par votre URL
    );
    const supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY', 
      defaultValue: 'your-anon-key', // Remplacez par votre clé
    );
    
    print('🔧 Configuration Supabase...');
    print('📍 URL: $supabaseUrl');
    print('🔑 Anon Key: ${supabaseAnonKey.length > 20 ? '${supabaseAnonKey.substring(0, 20)}...' : 'Non définie'}');
    
    // Vérifier si les variables sont correctement définies
    if (supabaseUrl == 'https://your-project.supabase.co' || 
        supabaseAnonKey == 'your-anon-key') {
      print('⚠️  Variables d\'environnement par défaut détectées');
      print('💡 Lancez avec: flutter run --dart-define-from-file=.env');
    }
    
    // Initialiser Supabase avec gestion d'erreur
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true,
    );
    
    print('✅ Supabase initialisé avec succès');
    
  } catch (e) {
    print('❌ Erreur d\'initialisation Supabase: $e');
    // Continuer même en cas d'erreur pour permettre le debug
  }
  
  runApp(const RecettePlusApp());
}

class RecettePlusApp extends StatelessWidget {
  const RecettePlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recette Plus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
        ),
        useMaterial3: true,
        fontFamily: 'SFProDisplay',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkInitialization();
  }

  Future<void> _checkInitialization() async {
    try {
      // Attendre un peu pour s'assurer que Supabase est initialisé
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Tester la connexion Supabase
      final client = Supabase.instance.client;
      print('🔍 Test de connexion Supabase...');
      
      // Test simple pour vérifier que Supabase fonctionne
      await client.from('profiles').select('id').limit(1);
      print('✅ Connexion Supabase OK');
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('⚠️  Erreur de connexion Supabase: $e');
      setState(() {
        _isInitialized = true; // Continuer même avec erreur
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo de l'application
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 16),
              const Text(
                'Initialisation...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connexion à Supabase',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Si erreur de connexion, afficher un message mais continuer
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                'Problème de connexion',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Vérifiez votre configuration Supabase',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Continuer vers l'application même avec erreur
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continuer quand même'),
              ),
            ],
          ),
        ),
      );
    }

    // Écouter les changements d'authentification
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Vérification de l\'authentification...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;
        
        print('🔐 État d\'authentification: ${session != null ? 'Connecté' : 'Déconnecté'}');
        if (session != null) {
          print('👤 Utilisateur: ${session.user.email}');
        }
        
        if (session != null) {
          return const MainNavigationPage();
        } else {
          return const WelcomePage();
        }
      },
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const RecipesPage(),
    const ProductsPage(),
    const VideosPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_rounded),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Recettes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_rounded),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Produits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_rounded),
              activeIcon: Icon(Icons.video_library),
              label: 'Vidéos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Panier',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}