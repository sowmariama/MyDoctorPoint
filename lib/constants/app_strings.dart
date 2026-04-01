// lib/constants/app_strings.dart

class AppStrings {
  // --- Navigation Onboarding ---
  static const String skip = 'Ignorer';
  static const String continue_ = 'Suivant';
  static const String getStarted = 'Démarrer';
  static const String back = 'Précédent';

  // --- Onboarding Pages ---
  static const List<Map<String, String>> onboardingPages = [
    {
      'title': 'Des spécialistes près de vous',
      'description': 'Trouvez facilement un médecin qualifié parmi notre réseau de professionnels de santé disponibles.',
    },
    {
      'title': 'Consultez sans vous déplacer',
      'description': 'Échangez avec votre médecin par message, appel vocal ou vidéo depuis chez vous.',
    },
    {
      'title': 'Votre santé, notre priorité',
      'description': 'Prenez rendez-vous en quelques clics et suivez vos consultations en toute sérénité.',
    },
  ];

  // --- Auth Choice Screen ---
  static const String welcomeTo = 'Bienvenue sur';
  static const String appNameBig = 'DOCTORPOINT';
  static const String tagline = 'Consultez un médecin, où que vous soyez';
  static const String createAccountFree = 'Créer un compte gratuitement';
  static const String seConnecter = 'Se connecter';
  static const String quickAccess = 'Accès rapide';
  static const String exploreGuest = 'Explorer sans créer de compte';
  static const String termsText = 'En continuant, vous acceptez nos Conditions d\'utilisation et notre Politique de confidentialité.';

  // --- Register Screen ---
  static const String inscription = 'Inscription';
  static const String createYourHealthSpace = 'Créez votre espace santé';
  static const String step1of3 = 'Étape 1/3 : Créez vos identifiants';
  static const String fillBasicInfo = 'Remplissez vos informations de base pour commencer';
  static const String fullName = 'Nom complet *';
  static const String email = 'Adresse email *';
  static const String phone = 'Numéro de téléphone';
  static const String password = 'Mot de passe *';
  static const String acceptTerms = "J'accepte les Conditions d'utilisation et la Politique de confidentialité de DoctorPoint";
  static const String createMyAccount = 'Créer mon compte';
  static const String alreadyHaveAccount = 'Vous avez déjà un compte ? ';

  // --- Login Screen ---
  static const String welcomeBack = 'Content de vous revoir';
  static const String accessYourSpace = 'Accédez à votre espace santé personnalisé';
  static const String forgotPassword = 'Mot de passe oublié ?';
  static const String newOnDoctorPoint = 'Nouveau sur DoctorPoint ?';
  static const String createAccount = 'Créer un compte';

  // --- Common Hints ---
  static const String nameHint = 'Jean Dupont';
  static const String emailHint = 'exemple@email.com';
  static const String phoneHint = '+221 XX XXX XX XX';
  static const String passwordHint = '••••••••';

  // --- Password Requirements ---
  static const String min8Chars = 'Minimum 8 caractères';
  static const String atLeastUppercase = 'Au moins une majuscule';
  static const String atLeastNumber = 'Au moins un chiffre';

  // --- Patient Details & Payment ---
  static const String patientInfo = 'Informations patient';
  static const String appointmentSummary = 'Résumé du rendez-vous';
  static const String personalInfo = 'Informations personnelles';
  static const String proceedToPayment = 'Procéder au paiement';
  static const String paymentSecure = 'Paiement sécurisé';
  static const String choosePaymentMethod = 'Choisissez votre moyen de paiement';
  static const String payNow = 'Payer maintenant';
  static const String paymentSuccess = 'Paiement réussi !';
  static const String backToHome = 'Retour à l\'accueil';

  // --- Home & Others ---
  static const String searchHint = 'Rechercher un médecin, une spécialité...';
  static const String popularDoctors = 'Médecins populaires';
  static const String seeAll = 'Voir tout';
  static const String myAppointments = 'Mes rendez-vous';
  static const String noAppointmentsYet = 'Aucun rendez-vous';
  static const String noAppointmentsDesc = 'Vous n\'avez pas encore de rendez-vous programmé.';

  // --- Appointments Screen (ajouts) ---
  static const String loadingAppointments = 'Chargement de vos rendez-vous...';
  static const String defaultDoctor = 'Médecin';
  static const String voiceCall = 'Appel vocal';
  static const String videoCall = 'Appel vidéo';
  static const String messaging = 'Messagerie';
  static const String completedStatus = 'Effectué';
  static const String confirmedStatus = 'Validé';
  static const String noAppointmentsTitle = 'Pas encore de rendez-vous';
  static const String findDoctorButton = 'Trouver un médecin';
  static const String myConsultations = 'Mes consultations'; // optionnel

    // --- Login / Register additional texts ---
  static const String resetPasswordTitle = 'Réinitialiser le mot de passe';
  static const String resetPasswordMessage = 'Entrez votre email pour recevoir un lien de réinitialisation.';
  static const String alreadyRegistered = 'Déjà inscrit ?';
  static const String stepInfo = 'Informations';
  static const String stepProfile = 'Profil';
  static const String stepConfirmation = 'Confirmation';
  static const String appNameUpper = 'DOCTORPOINT';
}

