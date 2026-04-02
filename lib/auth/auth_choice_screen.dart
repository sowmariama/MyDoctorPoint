// lib/auth/auth_choice_screen.dart
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fond clair comme sur Figma
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // Logo centré
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 82,
                ),
              ),

              const SizedBox(height: 40),

              // Texte principal
              const Text(
                "Prenez rendez-vous avec un spécialiste\nen quelques clics.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Patients et médecins réunis sur une seule plateforme\npour des soins rapides, simples et accessibles.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.5,
                  height: 1.45,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 50),

              // Bouton principal - Créer un compte
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981), // Vert comme sur Figma
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_rounded, size: 22),
                      SizedBox(width: 10),
                      Text(
                        "Créer un compte gratuitement",
                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bouton secondaire - Se connecter
              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF10B981), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login_rounded, size: 22, color: Color(0xFF10B981)),
                      SizedBox(width: 10),
                      Text(
                        "Se connecter",
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Accès rapide
              const Text(
                "Accès rapide",
                style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: () {
                  // Mode invité
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_outlined, size: 20, color: Color(0xFF6B7280)),
                    SizedBox(width: 8),
                    Text(
                      "Explorer sans créer de compte",
                      style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Mentions légales
              Text.rich(
                TextSpan(
                  text: "En continuant, vous acceptez nos ",
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF9CA3AF)),
                  children: const [
                    TextSpan(
                      text: "Conditions d'utilisation",
                      style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: " et notre "),
                    TextSpan(
                      text: "Politique de confidentialité",
                      style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: "."),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}