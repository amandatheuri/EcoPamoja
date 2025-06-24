import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPrompt2 extends StatelessWidget {
  const LoginPrompt2({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Expanded(
        child: Text(
          'Don\'t have an account?',
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
          
          Expanded(
            child: TextButton(
              onPressed: () => context.push('/signup'),
              child: Text(
                'Sign up',
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