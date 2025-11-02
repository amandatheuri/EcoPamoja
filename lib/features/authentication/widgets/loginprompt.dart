import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Don\'t have an account?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),

        TextButton(
          onPressed: () => context.push('/signup'),
          child: Text(
            'Create Account',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14.0,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
