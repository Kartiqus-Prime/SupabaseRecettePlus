class Validators {
  // Validation de l'email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'adresse e-mail est requise';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value.trim())) {
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

  // Validation du numéro de téléphone (optionnel pour le Mali)
  static String? validatePhoneNumber(String? value) {
    // Si le champ est vide, c'est valide car optionnel
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    final phone = value.trim();
    
    // Formats acceptés pour le Mali:
    // +223 XX XX XX XX (avec espaces)
    // +223XXXXXXXX (sans espaces)
    // 223XXXXXXXX (sans +)
    // XXXXXXXX (8 chiffres locaux)
    
    // Supprimer tous les espaces et tirets
    final cleanPhone = phone.replaceAll(RegExp(r'[\s-]'), '');
    
    // Vérifier les différents formats maliens
    final maliPatterns = [
      RegExp(r'^\+223[0-9]{8}$'),  // +223XXXXXXXX
      RegExp(r'^223[0-9]{8}$'),    // 223XXXXXXXX
      RegExp(r'^[0-9]{8}$'),       // XXXXXXXX (numéro local)
    ];
    
    bool isValid = false;
    for (final pattern in maliPatterns) {
      if (pattern.hasMatch(cleanPhone)) {
        isValid = true;
        break;
      }
    }
    
    if (!isValid) {
      return 'Format invalide. Ex: +223 XX XX XX XX ou 8 chiffres';
    }
    
    return null;
  }

  // Validation de l'âge (optionnel)
  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }
    
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Veuillez entrer un âge valide';
    }
    
    if (age < 13) {
      return 'Vous devez avoir au moins 13 ans';
    }
    
    if (age > 120) {
      return 'Veuillez entrer un âge réaliste';
    }
    
    return null;
  }

  // Validation de la bio (optionnel)
  static String? validateBio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }
    
    if (value.trim().length > 500) {
      return 'La bio ne peut pas dépasser 500 caractères';
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

  // Validation de l'URL (optionnel)
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value.trim())) {
      return 'Veuillez entrer une URL valide';
    }
    
    return null;
  }
}
