import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/constants/app_colors.dart';
import '../constants/app_strings.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Veuillez vous connecter")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.myAppointments,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.95), AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true) // Plus récents en premier
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _emptyState(context);
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final data = appointments[index].data() as Map<String, dynamic>;
              final appointmentId = appointments[index].id;
              return _appointmentCard(context, data, appointmentId);
            },
          );
        },
      ),
    );
  }

  // ====================== CARTE DE RENDEZ-VOUS ======================
  Widget _appointmentCard(
      BuildContext context, Map<String, dynamic> data, String appointmentId) {
    final doctorName = data['doctorName'] ?? 'Médecin inconnu';
    final date = data['date'] ?? '';
    final time = data['time'] ?? '';
    final price = data['price'] ?? 0;
    final status = data['status']?.toString().toLowerCase() ?? 'pending';
    final type = data['consultationType']?.toString() ?? 'voice';

    // Mapping des types
    final typeInfo = {
      'voice': {'label': 'Appel vocal', 'icon': Icons.phone_rounded, 'color': Colors.blue},
      'video': {'label': 'Appel vidéo', 'icon': Icons.videocam_rounded, 'color': Colors.purple},
      'message': {'label': 'Messagerie', 'icon': Icons.chat_bubble_rounded, 'color': Colors.green},
    }[type] ?? {'label': type, 'icon': Icons.medical_services, 'color': AppColors.primary};

    // Statut
    final isCompleted = status == 'completed';
    final statusColor = isCompleted ? Colors.green : AppColors.primary;
    final statusText = isCompleted ? 'Terminé' : 'Confirmé';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // TODO: Naviguer vers détail du rendez-vous plus tard
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Détail du rendez-vous bientôt disponible')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête : Médecin + Statut + Prix
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            typeInfo['label'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$price FCFA',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(height: 28, thickness: 1, color: Color(0xFFF0F0F0)),

                // Date et Heure
                Row(
                  children: [
                    _infoRow(Icons.calendar_today_rounded, date),
                    const SizedBox(width: 24),
                    _infoRow(Icons.access_time_rounded, time),
                  ],
                ),

                const SizedBox(height: 12),

                // Type de consultation (badge plus joli)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: (typeInfo['color'] as Color).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        typeInfo['icon'] as IconData,
                        size: 18,
                        color: typeInfo['color'] as Color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        typeInfo['label'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: typeInfo['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ====================== ÉTAT VIDE ======================
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 80,
                color: AppColors.primary.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Aucun rendez-vous',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Vous n\'avez pas encore pris de rendez-vous.\nCommencez dès maintenant !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Navigation vers Home ou recherche de médecins
                Navigator.pop(context); // Retour à l'accueil pour l'instant
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              icon: const Icon(Icons.search_rounded),
              label: const Text(
                'Trouver un médecin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}