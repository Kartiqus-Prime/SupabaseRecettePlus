class Validators {
  // Validation du nom complet
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom complet est requis';
    }
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    if (value.trim().length > 50) {
      return 'Le nom ne peut pas dépasser 50 caractères';
    }
    // Vérifier que le nom contient au moins un prénom et un nom
    final parts = value.trim().split(' ');
    if (parts.length < 2) {
      return 'Veuillez entrer votre prénom et nom';
    }
    return null;
  }

  // Validation de l'email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'adresse email est requise';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Veuillez entrer une adresse email valide';
    }
    
    return null;
  }

  // Validation du mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if (value.length > 128) {
      return 'Le mot de passe ne peut pas dépasser 128 caractères';
    }
    
    // Vérifier qu'il contient au moins une lettre et un chiffre
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une lettre et un chiffre';
    }
    
    return null;
  }

  // Validation de la confirmation du mot de passe
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  // Validation du numéro de téléphone (optionnel pour le Mali)
  static String? validatePhoneNumber(String? value) {
    // Si le champ est vide, c'est valide car optionnel
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    final phone = value.trim();
    
    // Formats acceptés pour le Mali:
    // +223 XX XX XX XX
    // 223 XX XX XX XX  
    // XX XX XX XX (8 chiffres)
    
    // Supprimer tous les espaces et tirets
    final cleanPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
    
    // Vérifier les formats maliens
    if (RegExp(r'^\+223[0-9]{8}$').hasMatch(cleanPhone)) {
      return null; // Format +223XXXXXXXX
    }
    if (RegExp(r'^223[0-9]{8}$').hasMatch(cleanPhone)) {
      return null; // Format 223XXXXXXXX
    }
    if (RegExp(r'^[0-9]{8}$').hasMatch(cleanPhone)) {
      return null; // Format XXXXXXXX (8 chiffres)
    }
    
    return 'Format invalide. Utilisez: +223 XX XX XX XX ou XX XX XX XX';
  }

  // Validation générique pour les champs requis
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  // Validation de la longueur minimale
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    if (value.trim().length < minLength) {
      return '$fieldName doit contenir au moins $minLength caractères';
    }
    return null;
  }

  // Validation de la longueur maximale
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName ne peut pas dépasser $maxLength caractères';
    }
    return null;
  }
}
