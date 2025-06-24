//this page defines the skip button and the progress navigation button
// ignore_for_file: use_build_context_synchronously
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecopamoja/features/onboarding/providers/onboarding_provider.dart';
import 'package:ecopamoja/features/onboarding/data/onboarding_data.dart';
import 'package:ecopamoja/features/onboarding/widgets/onboarding_page.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

 Future<void> _skipOnboarding() async {
  await OnboardingController.markOnboardingComplete();
  if (mounted) {
    try {
      context.go('/'); // Navigate using GoRouter
    } catch (e) {
      debugPrint('Navigation error: $e');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingProvider);
    final controller = ref.read(onboardingProvider.notifier);
    

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingItems.length,
            onPageChanged: controller.goToPage,
            itemBuilder: (_, index) => OnboardingPage(item: onboardingItems[index]),
          ),
          
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: TextButton(
              onPressed: _skipOnboarding,
              child: const Text(
                'Skip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // Progress Navigation Button
             Positioned(
              bottom: 40,
              left: 0,
              right: 0,
               child:  Center(
                 child: GestureDetector(
                  onTap: () async {
                   if (currentPage == onboardingItems.length - 1) {
                    await OnboardingController.markOnboardingComplete();
                    if (mounted) {
            try {
               context.go('/');
            } catch (e) {
              debugPrint('Navigation error: $e');
            }
          }
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          value: (currentPage + 1) / onboardingItems.length,
                          strokeWidth: 2,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          currentPage == onboardingItems.length - 1
                              ? Icons.done
                              : Icons.arrow_forward,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                             ),
               ),
             ),
        
        ],
      ),
    );
  }
}