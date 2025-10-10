import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';

class SignUpDivider extends StatelessWidget {
  const SignUpDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            // ignore: deprecated_member_use
            color: AppColors.secondary.withOpacity(0.5),
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'OR SignUp with',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.secondary)
          ),
        ),
        Expanded(
          child: Divider(
            // ignore: deprecated_member_use
            color: AppColors.secondary.withOpacity(0.5),
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}