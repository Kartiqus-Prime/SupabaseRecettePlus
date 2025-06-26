class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'adresse e-mail est requise';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Adresse e-mail invalide';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    }
    
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    
    return null;
  }
  
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom complet est requis';
    }
    
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    
    return null;
  }

  // Validation optionnelle pour le numéro de téléphone (pas de vérification requise)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Le numéro de téléphone est optionnel
    }
    
    // Validation basique du format (au moins 10 chiffres)
    final phoneRegex = RegExp(r'^\+?[\d\s\-$$$$]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Format de numéro de téléphone invalide';
    }
    
    return null;
  }
}
