class Validators {
  // Validation de l'email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'adresse e-mail est requise';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse e-mail valide';
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

  // Validation du nom complet
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom complet est requis';
    }
    
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    
    // Vérifier qu'il contient au moins un prénom et un nom
    final parts = value.trim().split(' ');
    if (parts.length < 2) {
      return 'Veuillez entrer votre prénom et nom';
    }
    
    return null;
  }

  // Validation du numéro de téléphone (optionnel pour le Mali)
  static String? validatePhoneNumber(String? value) {
    // Si le champ est vide, c'est valide (optionnel)
    if (value == null || value.isEmpty) {
      return null;
    }
    
    // Nettoyer le numéro (supprimer espaces et tirets)
    final cleanNumber = value.replaceAll(RegExp(r'[\s\-$$$$]'), '');
    
    // Formats acceptés pour le Mali :
    // +22312345678, +22376543210, +22390123456, +22370123456
    // 22312345678, 22376543210, 22390123456, 22370123456
    // 76543210, 90123456, 70123456, 12345678
    
    final maliRegex = RegExp(r'^(\+223|223)?[67890]\d{7}$');
    
    if (!maliRegex.hasMatch(cleanNumber)) {
      return 'Format invalide. Ex: +223 76 54 32 10 ou 76 54 32 10';
    }
    
    return null;
  }

  // Validation générique pour les champs requis
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  // Validation de l'âge
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optionnel
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Veuillez entrer un âge valide';
    }
    
    if (age < 13 || age > 120) {
      return 'L\'âge doit être entre 13 et 120 ans';
    }
    
    return null;
  }

  // Validation de la bio
  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optionnel
    }
    
    if (value.length > 500) {
      return 'La bio ne peut pas dépasser 500 caractères';
    }
    
    return null;
  }
}
