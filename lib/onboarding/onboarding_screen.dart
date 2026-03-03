import 'package:doctor_point/core/constants/app_colors.dart';
import 'package:doctor_point/constants/app_strings.dart'; // Nouvel import
import 'package:flutter/material.dart';
import '../auth/auth_choice_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  // Les données sont maintenant dans AppStrings.onboardingPages
  final List<Map<String, String>> _pages = AppStrings.onboardingPages.map((page) {
    // On ajoute le chemin de l'image (identique à avant)
    return {
      'image': 'assets/images/onboard${_pages.indexOf(page) + 1}.png',
      'title': page['title']!,
      'desc': page['description']!,
    };
  }).toList();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button (Top Right)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                child: TextButton(
                  onPressed: _goToAuthScreen,
                  child: Text(
                    AppStrings.skip,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Bottom Navigation & Button Section
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, String> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Image Container (identique)
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: -30,
                  top: 30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: 40,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                  ),
                ),
                Hero(
                  tag: 'onboarding_image',
                  child: Image.asset(
                    page['image']!,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Column(
            children: [
              Text(
                page['title']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: _currentIndex == _pages.indexOf(page) ? 80 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              page['desc']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _currentIndex == index ? 24 : 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.primary
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _currentIndex == index
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleButtonPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 32,
                ),
                elevation: 2,
                shadowColor: AppColors.primary.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentIndex == _pages.length - 1
                        ? AppStrings.getStarted
                        : AppStrings.continue_,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_currentIndex != _pages.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.arrow_forward_rounded, size: 20),
                    ),
                ],
              ),
            ),
          ),

          if (_currentIndex > 0) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _controller.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                AppStrings.back,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleButtonPress() {
    if (_currentIndex == _pages.length - 1) {
      _goToAuthScreen();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToAuthScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AuthChoiceScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}