import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  bool _isLoading = false;
  bool _isLoadingProfile = true;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final profile = await _firestoreService.getUserProfile(user.uid);
      if (profile != null) {
        setState(() {
          _fullNameController.text = profile['fullName'] ?? '';
          _emailController.text = profile['email'] ?? user.email ?? '';
          _phoneController.text = profile['phoneNumber'] ?? '';
          _ageController.text = profile['age']?.toString() ?? '';
          _bioController.text = profile['bio'] ?? '';
        });
      } else {
        // Si le profil n'existe pas, utiliser les données de Firebase Auth
        setState(() {
          _emailController.text = user.email ?? '';
          _fullNameController.text = user.displayName ?? '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement du profil';
      });
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Mettre à jour le profil dans Firestore
      await _firestoreService.updateUserProfile(
        uid: user.uid,
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        age: _ageController.text.trim().isEmpty 
            ? null 
            : int.tryParse(_ageController.text.trim()),
        bio: _bioController.text.trim().isEmpty 
            ? null 
            : _bioController.text.trim(),
      );

      // Mettre à jour le nom d'affichage dans Firebase Auth
      if (_fullNameController.text.trim() != user.displayName) {
        await user.updateDisplayName(_fullNameController.text.trim());
      }

      setState(() {
        _successMessage = 'Profil mis à jour avec succès';
      });

      // Retourner à la page précédente après 2 secondes
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });

    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la mise à jour du profil';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Modifier le profil',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoadingProfile
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Messages d'erreur/succès
                      if (_errorMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.error.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (_successMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _successMessage!,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Champs du formulaire
                      CustomTextField(
                        label: AppStrings.fullName,
                        controller: _fullNameController,
                        validator: Validators.validateFullName,
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        label: AppStrings.email,
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        enabled: false, // L'email ne peut pas être modifié
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Numéro de téléphone (optionnel)',
                        controller: _phoneController,
                        validator: Validators.validatePhoneNumber,
                        keyboardType: TextInputType.phone,
                        hintText: 'Ex: +223 76 54 32 10',
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Âge (optionnel)',
                        controller: _ageController,
                        validator: Validators.validateAge,
                        keyboardType: TextInputType.number,
                        hintText: 'Votre âge',
                        prefixIcon: const Icon(
                          Icons.cake_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      CustomTextField(
                        label: 'Bio (optionnel)',
                        controller: _bioController,
                        validator: Validators.validateBio,
                        maxLines: 3,
                        hintText: 'Parlez-nous de vous...',
                        prefixIcon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Bouton de sauvegarde
                      CustomButton(
                        text: 'Sauvegarder les modifications',
                        onPressed: _updateProfile,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
