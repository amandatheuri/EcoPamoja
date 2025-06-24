// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:ecopamoja/features/authentication/controllers/auth_controller.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContinueWith extends ConsumerWidget {
  const ContinueWith({super.key});

  Future<void> handleSignIn(BuildContext context, WidgetRef ref) async {
    final user = await ref.read(authControllerProvider).signInWithGoogle();
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in as ${user.displayName}', style: AppTextStyles.bodyText),
          backgroundColor: AppColors.primary,
        ),
      );
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google Sign-In failed',
            style: AppTextStyles.bodyText,
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: GestureDetector(
        onTap: () => handleSignIn(context, ref),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              AppImages.googlelogo,
              height: 40,
              width: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
          ),
        ),
      ),
    );
  }
}
