import 'package:doctor_point/auth/login_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../profile/setup_profile_screen.dart';
import '../core/constants/app_colors.dart';
import '../constants/app_strings.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final AuthService auth = AuthService();
  bool loading = false;
  bool hidePassword = true;
  bool acceptTerms = false;

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
                const SizedBox(height: 40),
                _buildStepsIndicator(),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildNameField(),
                      const SizedBox(height: 20),
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      _buildPhoneField(),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 24),
                      _buildTermsCheckbox(),
                      const SizedBox(height: 36),
                      _buildRegisterButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildDivider(),
                const SizedBox(height: 32),
                _buildLoginLink(),
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
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.inscription,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
        ),
        const SizedBox(height: 8),
        Text(AppStrings.createYourHealthSpace, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStepsIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStepCircle(1, AppStrings.stepInfo, true),
              _buildStepLine(true),
              _buildStepCircle(2, AppStrings.stepProfile, false),
              _buildStepLine(false),
              _buildStepCircle(3, AppStrings.stepConfirmation, false),
            ],
          ),
          const SizedBox(height: 16),
          Text(AppStrings.step1of3, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(AppStrings.fillBasicInfo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int number, String label, bool active) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primary : AppColors.border,
          ),
          child: Center(
            child: Text('$number', style: TextStyle(color: active ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 11, color: active ? AppColors.primary : AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStepLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18, left: 8, right: 8),
        color: active ? AppColors.primary : AppColors.border,
      ),
    );
  }

  // Les champs (_buildNameField, _buildEmailField, _buildPhoneField, _buildPasswordField) restent très similaires 
  // mais avec des bordures et espacements améliorés (je les ai rendus plus cohérents avec LoginScreen).

  Widget _buildNameField() {
    return _buildTextField(
      label: AppStrings.fullName,
      controller: nameCtrl,
      hint: AppStrings.nameHint,
      icon: Icons.person_rounded,
      validator: (value) => (value == null || value.isEmpty) ? 'Veuillez entrer votre nom' : (value.split(' ').length < 2 ? 'Nom complet requis' : null),
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      label: AppStrings.email,
      controller: emailCtrl,
      hint: AppStrings.emailHint,
      icon: Icons.email_rounded,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => (value == null || value.isEmpty) ? 'Email requis' : (!value.contains('@') ? 'Email invalide' : null),
    );
  }

  Widget _buildPhoneField() {
    return _buildTextField(
      label: AppStrings.phone,
      controller: phoneCtrl,
      hint: AppStrings.phoneHint,
      icon: Icons.phone_rounded,
      keyboardType: TextInputType.phone,
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
          validator: (value) {
            if (value == null || value.length < 8) return AppStrings.min8Chars;
            if (!RegExp(r'[A-Z]').hasMatch(value)) return AppStrings.atLeastUppercase;
            if (!RegExp(r'[0-9]').hasMatch(value)) return AppStrings.atLeastNumber;
            return null;
          },
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.border, width: 1.5))),
              child: Icon(icon, color: AppColors.primary),
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

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: acceptTerms,
          onChanged: (v) => setState(() => acceptTerms = v ?? false),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => acceptTerms = !acceptTerms),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(AppStrings.acceptTerms, style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: (loading || !acceptTerms) ? null : _register,
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
                  const Icon(Icons.person_add_alt_1_rounded, size: 22),
                  const SizedBox(width: 12),
                  Text(AppStrings.createMyAccount, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
          child: Text(AppStrings.alreadyRegistered, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.alreadyHaveAccount, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
        TextButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
          child: Text(AppStrings.seConnecter, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary)),
        ),
      ],
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    try {
      final user = await auth.register(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
        fullName: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SetupProfileScreen(uid: user.uid)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().contains('email-already-in-use') ? 'Cet email est déjà utilisé' : 'Erreur lors de l\'inscription'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() => loading = false);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    nameCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}