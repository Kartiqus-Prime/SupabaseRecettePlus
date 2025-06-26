class Validators {
  // Validation de l'email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre adresse email';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse email valide';
    }
    
    return null;
  }

  // Validation du mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
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
      return 'Veuillez entrer votre nom complet';
    }
    
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    
    return null;
  }

  // Validation du numéro de téléphone (optionnel)
  static String? validatePhoneNumber(String? value) {
    // Si le champ est vide, c'est valide car optionnel
    if (value == null || value.isEmpty) {
      return null;
    }
    
    // Supprimer les espaces et caractères spéciaux pour la validation
    String cleanedValue = value.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Vérifier le format de base
    if (cleanedValue.length < 8) {
      return 'Numéro de téléphone trop court';
    }
    
    if (cleanedValue.length > 15) {
      return 'Numéro de téléphone trop long';
    }
    
    // Validation spécifique pour les numéros maliens
    if (cleanedValue.startsWith('+223')) {
      String number = cleanedValue.substring(4);
      if (number.length != 8) {
        return 'Format malien: +223XXXXXXXX (8 chiffres)';
      }
    } else if (cleanedValue.startsWith('223')) {
      String number = cleanedValue.substring(3);
      if (number.length != 8) {
        return 'Format malien: 223XXXXXXXX (8 chiffres)';
      }
    } else if (!cleanedValue.startsWith('+') && cleanedValue.length == 8) {
      // Numéro malien local (8 chiffres)
      if (!RegExp(r'^[67]\d{7}$').hasMatch(cleanedValue)) {
        return 'Numéro malien invalide (doit commencer par 6 ou 7)';
      }
    }
    
    return null;
  }

  // Validation du code de vérification
  static String? validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer le code de vérification';
    }
    
    if (value.length != 6) {
      return 'Le code doit contenir 6 chiffres';
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Le code ne doit contenir que des chiffres';
    }
    
    return null;
  }
}
