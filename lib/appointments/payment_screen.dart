import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/constants/app_colors.dart';
import 'payment_success_screen.dart';
import '../constants/app_strings.dart';

class PaymentScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String consultationType;
  final int price;
  final String date;
  final String time;

  const PaymentScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.consultationType,
    required this.price,
    required this.date,
    required this.time,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = 'wave';
  bool loading = false;

  final Map<String, Map<String, dynamic>> paymentMethods = {
    'wave': {
      'name': 'Wave',
      'icon': 'assets/images/wave.png',
      'color': const Color(0xFF00B2FF),
      'description': 'Paiement rapide et sécurisé',
    },
    'orange': {
      'name': 'Orange Money',
      'icon': 'assets/images/orange_money.png',
      'color': const Color(0xFFFF6B00),
      'description': 'Paiement mobile Orange',
    },
    'free': {
      'name': 'Free Money',
      'icon': 'assets/images/free_money.png',
      'color': const Color(0xFF8E44AD),
      'description': 'Paiement mobile Free',
    },
  };

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

  Future<void> _confirmPayment() async {
    if (!mounted) return;

    setState(() => loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final firestore = FirebaseFirestore.instance;

      final appointmentRef = await firestore.collection('appointments').add({
        'userId': user.uid,
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'consultationType': widget.consultationType,
        'price': widget.price,
        'date': widget.date,
        'time': widget.time,
        'paymentMethod': paymentMethod,
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Création de la notification
      await firestore.collection('notifications').add({
        'userId': user.uid,
        'title': 'Rendez-vous confirmé ✅',
        'message': 'Votre rendez-vous avec ${widget.doctorName} est confirmé pour le ${widget.date} à ${widget.time}.',
        'read': false,
        'appointmentId': appointmentRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Petite animation avant redirection
      await Future.delayed(const Duration(milliseconds: 800));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            doctorId: widget.doctorId,
            doctorName: widget.doctorName,
            doctorPhoto: '',
            consultationType: widget.consultationType,
            price: widget.price,
            date: widget.date,
            time: widget.time,
            paymentMethod: paymentMethod,
            method: paymentMethods[paymentMethod]!['name'] as String,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du paiement : ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.paymentSecure,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====================== RÉSUMÉ DU PAIEMENT ======================
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
                            const Text(
                              'Résumé du paiement',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              consultationTypeLabel,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _detailRow('Médecin', widget.doctorName),
                  _detailRow('Date', widget.date),
                  _detailRow('Heure', widget.time),
                  _detailRow('Type', consultationTypeLabel),

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

            // ====================== CHOIX DU MOYEN DE PAIEMENT ======================
            Text(
              AppStrings.choosePaymentMethod,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sélectionnez une option de paiement sécurisée',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 24),

            // Liste des moyens de paiement
            ...paymentMethods.entries.map((entry) {
              final key = entry.key;
              final data = entry.value;
              final isSelected = paymentMethod == key;

              return GestureDetector(
                onTap: () => setState(() => paymentMethod = key),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected ? (data['color'] as Color) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? (data['color'] as Color) : AppColors.border,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isSelected ? 0.12 : 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.25)
                              : (data['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Image.asset(
                          data['icon'] as String,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] as String,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['description'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected
                                    ? Colors.white.withOpacity(0.9)
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : AppColors.border,
                            width: 2,
                          ),
                          color: isSelected ? Colors.white : Colors.transparent,
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: data['color'] as Color,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 32),

            // Info sécurité
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_rounded, color: Color(0xFF388E3C)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Paiement 100% sécurisé • Vos données sont protégées',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF388E3C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Bouton Payer
            SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton(
                onPressed: loading ? null : _confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: loading
                    ? const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.payments_rounded, size: 22),
                          const SizedBox(width: 12),
                          Text(
                            '${AppStrings.payNow} ${widget.price} FCFA',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Bouton Annuler
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: loading ? null : () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Annuler',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
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
    );
  }
}