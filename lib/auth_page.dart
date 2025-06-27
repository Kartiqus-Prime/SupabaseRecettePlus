import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'core/services/supabase_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? _errorMessage;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _errorMessage = null;
    });
    
    if (kDebugMode) {
      print("AuthPage: Tentative de connexion par email/mot de passe...");
      print("AuthPage: Email: ${_emailController.text}");
    }
    
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      if (response.user != null) {
        if (kDebugMode) {
          print("AuthPage: ✅ Connexion réussie pour ${response.user?.email}");
        }
        
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } on AuthException catch (e) {
      if (kDebugMode) {
        print("AuthPage: ❌ Erreur de connexion Supabase: ${e.message}");
      }
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      if (kDebugMode) {
        print("AuthPage: 💥 Erreur inattendue lors de la connexion: $e");
      }
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _registerWithEmailAndPassword() async {
    setState(() {
      _errorMessage = null;
    });
    
    if (kDebugMode) {
      print("AuthPage: Tentative d'inscription par email/mot de passe...");
      print("AuthPage: Email: ${_emailController.text}");
    }
    
    try {
      final response = await _supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      if (response.user != null) {
        if (kDebugMode) {
          print("AuthPage: ✅ Inscription réussie pour ${response.user?.email}");
        }
        
        // Créer le profil utilisateur
        await SupabaseService.createUserProfile(
          uid: response.user!.id,
          displayName: response.user!.email?.split('@')[0] ?? 'Utilisateur',
          email: response.user!.email!,
        );
        
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } on AuthException catch (e) {
      if (kDebugMode) {
        print("AuthPage: ❌ Erreur d'inscription Supabase: ${e.message}");
      }
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      if (kDebugMode) {
        print("AuthPage: 💥 Erreur inattendue lors de l'inscription: $e");
      }
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _errorMessage = null;
    });
    
    if (kDebugMode) {
      print("AuthPage: Tentative de connexion avec Google...");
    }
    
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        if (kDebugMode) {
          print("AuthPage: ❌ Connexion Google annulée par l'utilisateur.");
        }
        return;
      }

      if (kDebugMode) {
        print("AuthPage: ✅ Utilisateur Google sélectionné: ${googleUser.email}");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (kDebugMode) {
        print("AuthPage: Access Token Google: ${googleAuth.accessToken != null ? '✅ Obtenu' : '❌ Manquant'}");
        print("AuthPage: ID Token Google: ${googleAuth.idToken != null ? '✅ Obtenu' : '❌ Manquant'}");
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.user != null) {
        if (kDebugMode) {
          print("AuthPage: ✅ Connexion Supabase avec Google réussie pour ${response.user?.email}");
        }
        
        // Vérifier si le profil existe, sinon le créer
        final existingProfile = await SupabaseService.getUserProfile(response.user!.id);
        if (existingProfile == null) {
          await SupabaseService.createUserProfile(
            uid: response.user!.id,
            displayName: response.user!.userMetadata?['full_name'] ?? 
                        response.user!.email?.split('@')[0] ?? 'Utilisateur',
            email: response.user!.email!,
          );
        }
        
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      }
    } on AuthException catch (e) {
      if (kDebugMode) {
        print("AuthPage: ❌ Erreur Supabase Auth (Google): ${e.message}");
      }
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      if (kDebugMode) {
        print("AuthPage: 💥 Erreur inattendue lors de la connexion Google: $e");
        print("AuthPage: Stack Trace: ${StackTrace.current}");
      }
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentification'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: const Text('Se connecter'),
            ),
            TextButton(
              onPressed: _registerWithEmailAndPassword,
              child: const Text('Créer un compte'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: SvgPicture.asset(
                'assets/images/google-logo.svg',
                height: 24.0,
                width: 24.0,
              ),
              label: const Text('Se connecter avec Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
