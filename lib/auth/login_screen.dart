import 'package:doctor_point/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../home/home_screen.dart';
import '../core/constants/app_colors.dart';
import '../constants/app_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final AuthService auth = AuthService();

  bool loading = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 48),
                _buildLogoCard(),
                const SizedBox(height: 48),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showForgotPasswordDialog,
                          child: Text(
                            AppStrings.forgotPassword,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildLoginButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 28),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.welcomeBack,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.accessYourSpace,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 68),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                AppStrings.appNameUpper,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => (value == null || value.isEmpty) ? 'Veuillez entrer votre email' : (!value.contains('@') ? 'Email invalide' : null),
          decoration: InputDecoration(
            hintText: AppStrings.emailHint,
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.border, width: 1.5))),
              child: const Icon(Icons.email_rounded, color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.password, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: passCtrl,
          obscureText: hidePassword,
          validator: (value) => (value == null || value.isEmpty) ? 'Veuillez entrer votre mot de passe' : (value.length < 6 ? 'Minimum 6 caractères' : null),
          decoration: InputDecoration(
            hintText: AppStrings.passwordHint,
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.border, width: 1.5))),
              child: const Icon(Icons.lock_rounded, color: AppColors.primary),
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => hidePassword = !hidePassword),
              icon: Icon(hidePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textSecondary),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: loading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login_rounded, size: 22),
                  const SizedBox(width: 12),
                  Text(AppStrings.seConnecter, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(AppStrings.newOnDoctorPoint, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.alreadyHaveAccount, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
        TextButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
          child: Text(AppStrings.createAccount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
        ),
      ],
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppStrings.resetPasswordTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(AppStrings.resetPasswordMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité de réinitialisation à venir'), backgroundColor: AppColors.primary),
              );
            },
            child: const Text('Envoyer le lien'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    try {
      final user = await auth.login(email: emailCtrl.text.trim(), password: passCtrl.text.trim());
      final profile = await auth.getUserProfile(user.uid);
      final fullName = profile['fullName'] ?? 'Utilisateur';

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(userName: fullName)));
    } on FirebaseAuthException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Identifiants incorrects'), backgroundColor: Colors.red.shade600, behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur de connexion'), backgroundColor: Colors.red));
    }
    setState(() => loading = false);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}