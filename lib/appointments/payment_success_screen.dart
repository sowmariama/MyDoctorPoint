import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../calls/voice_call_screen.dart';
import '../calls/video_call_screen.dart';
import '../chat/chat_screen.dart';
import '../home/home_screen.dart';
import '../constants/app_strings.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String consultationType;
  final String doctorId;
  final String doctorName;
  final String doctorPhoto;
  final int price;
  final String date;
  final String time;
  final String paymentMethod;
  final String method;

  const PaymentSuccessScreen({
    super.key,
    required this.consultationType,
    required this.doctorId,
    required this.doctorName,
    required this.doctorPhoto,
    required this.price,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.method,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isLoading = false;

  String get typeLabel {
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

  IconData get typeIcon {
    switch (widget.consultationType) {
      case 'voice':
        return Icons.call_rounded;
      case 'video':
        return Icons.videocam_rounded;
      case 'message':
        return Icons.chat_bubble_rounded;
      default:
        return Icons.medical_services_rounded;
    }
  }

  String get startButtonText {
    return widget.consultationType == 'message' 
        ? 'Ouvrir la messagerie' 
        : 'Démarrer $typeLabel';
  }

  void _startSession() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    if (widget.consultationType == 'voice') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VoiceCallScreen(
            doctorId: widget.doctorId,
            doctorName: widget.doctorName,
            doctorPhoto: widget.doctorPhoto,
          ),
        ),
      );
    } else if (widget.consultationType == 'video') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VideoCallScreen(
            doctorId: widget.doctorId,
            doctorName: widget.doctorName,
            doctorPhoto: widget.doctorPhoto,
          ),
        ),
      );
    } else if (widget.consultationType == 'message') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            doctorId: widget.doctorId,
            doctorName: widget.doctorName,
            doctorPhoto: widget.doctorPhoto,
          ),
        ),
      );
    }
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen(userName: 'Utilisateur')),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ====================== ICÔNE DE SUCCÈS ======================
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Titre de succès
              Text(
                AppStrings.paymentSuccess,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'Votre $typeLabel a été confirmé avec succès',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                '${widget.price} FCFA • ${widget.method}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 48),

              // ====================== DÉTAILS DU RENDEZ-VOUS ======================
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
                  children: [
                    _detailRow(Icons.person_rounded, 'Médecin', widget.doctorName),
                    const SizedBox(height: 20),
                    _detailRow(Icons.calendar_month_rounded, 'Date', widget.date),
                    const SizedBox(height: 20),
                    _detailRow(Icons.access_time_rounded, 'Heure', widget.time),
                    const SizedBox(height: 20),
                    _detailRow(typeIcon, 'Type de consultation', typeLabel),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // ====================== BOUTONS D'ACTION ======================
              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
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
                            Icon(typeIcon, size: 22),
                            const SizedBox(width: 12),
                            Text(
                              startButtonText,
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

              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: _goToHome,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.home_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.backToHome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}