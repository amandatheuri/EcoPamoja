// This file defines the OnboardingPage widget, which displays an onboarding item with an image and text.
import 'package:ecopamoja/features/onboarding/data/onboarding_data.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centers content vertically
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centers content horizontally
        children: [
          // Image section with aspect ratio protection
          SizedBox(
            width: screenHeight * 0.8,
            height: screenHeight * 0.5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(item.imagePath, fit: BoxFit.contain),
              ),
            ),
          ),

          // Text section with calculated spacing
          Container(
            padding: EdgeInsets.only(
              top: 0,
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // ignore: deprecated_member_use
                      color: Theme.of(
                        context,
                        // ignore: deprecated_member_use
                      ).colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
