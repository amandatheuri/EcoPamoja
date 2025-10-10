import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌿 Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboardingbackground.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🌱 Overlay content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Stack(
              children: [
                // Main Text
                Positioned(
                  top: 120,
                  left: 0,
                  child: Text(
                    "Save the\nplanet one\naction at a\ntime",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      height: 60 / 36, 
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),


                // Floating outline badges (angled)
                Positioned(
                  top: 50,
                  right: 0,
                  child: Transform.rotate(
                    angle: -0.15, // slight rotation
                    child: const _OutlinedBadge(
                      icon: Icons.check_circle,
                      text: "Complete\nchallenges",
                    ),
                  ),
                ),
                Positioned(
                  top: 390,
                  left: 0,
                  child: Transform.rotate(
                    angle: 0.1,
                    child: const _OutlinedBadge(
                      icon: Icons.group,
                      text: "Join\ngroups",
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  right: 0,
                  child: Transform.rotate(
                    angle: 0,
                    child: const _OutlinedBadge(
                      icon: Icons.calendar_today,
                      text: "Get\neco-updates",
                    ),
                  ),
                ),

                // ⭕ Circular button with outline
               Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer white ring (outline with gap)
                          Container(
                            width: 72, 
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.9),
                                width: 0.5,
                              ),
                            ),
                          ),

                          // Inner green circle
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlinedBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _OutlinedBadge({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 0.5),
        color: Colors.white.withOpacity(0.05), // transparent background
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🟢 Filled icon
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
