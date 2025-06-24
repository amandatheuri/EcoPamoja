import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),

        Expanded(
          child: TextButton(
            onPressed: () => context.push('/signup'),
            child: Text(
              'Create Account',
              style: AppTextStyles.bodyText.copyWith(
                fontSize: 14.0,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}