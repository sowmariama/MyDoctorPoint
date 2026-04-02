import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'payment_screen.dart';
import '../constants/app_strings.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String consultationType;
  final int price;
  final String date;
  final String time;

  const PatientDetailsScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.consultationType,
    required this.price,
    required this.date,
    required this.time,
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  String gender = 'Homme';
  final _formKey = GlobalKey<FormState>();

  String get consultationTypeLabel {
    switch (widget.consultationType) {
      case 'voice':
        return 'Appel vocal';
      case 'video':
        return 'Appel vidéo';
      case 'message':
        return 'Messagerie';
      default:
        return widget.consultationType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.patientInfo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================== RÉSUMÉ DU RENDEZ-VOUS ======================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.medical_services_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.appointmentSummary,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Vérifiez les détails avant de continuer',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _infoRow(Icons.person_outline_rounded, 'Médecin', widget.doctorName),
                    _infoRow(Icons.calendar_month_rounded, 'Date', widget.date),
                    _infoRow(Icons.access_time_rounded, 'Heure', widget.time),
                    _infoRow(Icons.medical_services_outlined, 'Type de consultation', consultationTypeLabel),

                    const SizedBox(height: 20),
                    const Divider(color: AppColors.border, thickness: 1),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total à payer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${widget.price} FCFA',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ====================== INFORMATIONS PERSONNELLES ======================
              Text(
                AppStrings.personalInfo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ces informations seront utilisées pour votre consultation',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Nom complet
              _buildLabel(AppStrings.fullName),
              const SizedBox(height: 8),
              _buildTextField(
                controller: nameCtrl,
                hintText: 'Ex: Fatou Ndiaye',
                icon: Icons.person_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Veuillez entrer votre nom complet';
                  if (value.trim().split(' ').length < 2) return 'Veuillez entrer nom et prénom';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Âge
              _buildLabel('Âge *'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: ageCtrl,
                hintText: 'Ex: 28',
                icon: Icons.cake_rounded,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Veuillez entrer votre âge';
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 120) return 'Âge invalide (1-120)';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Genre
              _buildLabel('Genre *'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: gender,
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.expand_more_rounded, color: AppColors.textPrimary),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Homme',
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Homme'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Femme',
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Femme'),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => gender = value);
                    },
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Bouton Continuer vers le paiement
              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            doctorId: widget.doctorId,
                            doctorName: widget.doctorName,
                            consultationType: widget.consultationType,
                            price: widget.price,
                            date: widget.date,
                            time: widget.time,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.payments_rounded, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        AppStrings.proceedToPayment,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bouton Retour
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('Retour', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6)),
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: AppColors.border, width: 1.5)),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }
}