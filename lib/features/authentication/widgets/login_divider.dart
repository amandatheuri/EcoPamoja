import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

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
            'OR login with',
            style: AppTextStyles.bodyText.copyWith(
              fontSize: 14.0,
              color: AppColors.secondary,
            ),
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