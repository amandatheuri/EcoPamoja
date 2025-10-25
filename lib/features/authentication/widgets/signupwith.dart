// ignore_for_file: use_build_context_synchronously

import 'package:ecopamoja/features/authentication/controllers/auth_controller.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpWith extends ConsumerWidget {
  const SignUpWith({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleSignIn(BuildContext context)async{
      final user = await ref.read(authControllerProvider).signInWithGoogle();
      if (user != null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign in as ${user.displayName}', style: Theme.of(context).textTheme.bodySmall),backgroundColor: AppColors.primary,));
        context.go('/navigation');
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign in failed', style: Theme.of(context).textTheme.bodySmall),backgroundColor: AppColors.primary,));
      }
    }
    return Center(
                  child: GestureDetector(
                    onTap: () => handleSignIn(context),
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
                            // This will show if the image fails to load
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                    ),
                  ),
  );
  }
}