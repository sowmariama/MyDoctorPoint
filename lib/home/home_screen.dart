import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_point/settings/settings_screen.dart';
import '../core/constants/app_colors.dart';
import '../doctors/doctor_detail_screen.dart';
import '../doctors/mock_doctors.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../appointments/appointments_screen.dart';
import '../constants/app_strings.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showSearchResults = false;

  // Variables utilisateur
  String _userName = 'Chargement...';
  String? _userPhotoUrl;
  String? _userInitial;

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          final fullName = data['fullName'] ?? data['name'] ?? user.displayName ?? widget.userName;

          setState(() {
            _userName = fullName;
            _userInitial = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
            _userPhotoUrl = data['photoUrl'] ?? user.photoURL;
          });
        }
      }
    } catch (e) {
      print('Erreur de chargement des données utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ==================== HEADER ====================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  _buildUserHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================== CONTENU PRINCIPAL ====================
            Expanded(
              child: _showSearchResults && _searchQuery.isNotEmpty
                  ? _buildSearchResults()
                  : _buildMainContent(),
            ),
          ],
        ),
      ),

      // ==================== BOTTOM NAVIGATION ====================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);

              if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentsScreen()));
              }
              if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }
              if (index == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: const Color(0xFFA0A5BA),
            selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(0, Icons.home_filled, Icons.home_outlined),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(1, Icons.calendar_month_rounded, Icons.calendar_today_outlined),
                label: 'RDV',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(2, Icons.settings_rounded, Icons.settings_outlined),
                label: 'Paramètres',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(3, Icons.person_rounded, Icons.person_outline),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(int index, IconData filledIcon, IconData outlinedIcon) {
    final isSelected = _currentIndex == index;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
      ),
      child: Icon(
        isSelected ? filledIcon : outlinedIcon,
        size: 24,
      ),
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        // Avatar
        _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
            ? Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
                  image: DecorationImage(image: NetworkImage(_userPhotoUrl!), fit: BoxFit.cover),
                ),
              )
            : Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    _userInitial ?? 'U',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ),

        const SizedBox(width: 16),

        // Message de bienvenue
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour, ${_getFirstName()} 👋',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Trouvez le meilleur soin médical',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        // Notification Bell
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .where('read', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            final unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 24),
                    if (unreadCount > 0)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getFirstName() {
    if (_userName.contains(' ')) {
      return _userName.split(' ')[0];
    }
    return _userName;
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _showSearchResults = value.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6), fontSize: 15),
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 16, right: 12),
            child: const Icon(Icons.search_rounded, color: AppColors.primary, size: 24),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _showSearchResults = false;
                    });
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services médicaux',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          _buildMedicalServices(),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Médecins populaires',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Voir tout',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildPopularDoctors(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMedicalServices() {
    final services = [
      {'icon': Icons.video_camera_back_rounded, 'label': 'Consultation\nen ligne', 'gradient': [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]},
      {'icon': Icons.local_hospital_rounded, 'label': 'Médecine\ngénérale', 'gradient': [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)]},
      {'icon': Icons.medical_services_rounded, 'label': 'Spécialistes', 'gradient': [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)]},
      {'icon': Icons.local_pharmacy_rounded, 'label': 'Pharmacie', 'gradient': [const Color(0xFFFFF3E0), const Color(0xFFFFCC80)]},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: service['gradient'] as List<Color>, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
                      child: Icon(service['icon'] as IconData, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      service['label'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularDoctors() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockDoctors.length,
      itemBuilder: (context, index) {
        final doctor = mockDoctors[index];

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailScreen(doctor: doctor))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 6))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo
                Container(
                  width: 120,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    image: doctor.photoUrls != null && doctor.photoUrls!.isNotEmpty
                        ? DecorationImage(image: NetworkImage(doctor.photoUrls!), fit: BoxFit.cover)
                        : null,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: doctor.photoUrls == null || doctor.photoUrls!.isEmpty
                      ? Center(child: Text(doctor.fullName[0], style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.primary)))
                      : null,
                ),

                // Informations
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                doctor.fullName,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Text('${doctor.experienceYears} ans', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(doctor.specialty, style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(doctor.hospital, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 20),
                                const SizedBox(width: 6),
                                Text(doctor.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              ],
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final filteredDoctors = mockDoctors.where((doctor) {
      final query = _searchQuery.toLowerCase();
      return doctor.fullName.toLowerCase().contains(query) ||
          doctor.specialty.toLowerCase().contains(query) ||
          doctor.hospital.toLowerCase().contains(query);
    }).toList();

    if (filteredDoctors.isEmpty) return _buildNoResultsView();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text('${filteredDoctors.length} résultat${filteredDoctors.length > 1 ? 's' : ''}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _showSearchResults = false;
                  });
                  _searchController.clear();
                },
                icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                label: const Text('Effacer', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filteredDoctors.length,
            itemBuilder: (context, index) {
              final doctor = filteredDoctors[index];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailScreen(doctor: doctor))),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: doctor.photoUrls != null && doctor.photoUrls!.isNotEmpty ? DecorationImage(image: NetworkImage(doctor.photoUrls!), fit: BoxFit.cover) : null,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      child: doctor.photoUrls == null || doctor.photoUrls!.isEmpty
                          ? Center(child: Text(doctor.fullName[0], style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)))
                          : null,
                    ),
                    title: Text(doctor.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(doctor.specialty, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text(doctor.hospital, style: TextStyle(fontSize: 12, color: AppColors.textSecondary.withOpacity(0.7))),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB800)),
                            const SizedBox(width: 4),
                            Text(doctor.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResultsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.search_off_rounded, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text('Aucun résultat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text('Aucun médecin ne correspond à "$_searchQuery"', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _showSearchResults = false;
              });
              _searchController.clear();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
            child: const Text('Voir tous les médecins'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}