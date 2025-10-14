// ignore_for_file: deprecated_member_use

import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget glowingProfileCircle(BuildContext context, String? imageUrl) {
  return GestureDetector(
    onTap: () {
      context.push('/user-profile');
    },
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.complimentary.withOpacity(0.4), // subtle glow
            offset: const Offset(0, 6), // only bottom
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
        child: imageUrl == null
            ? Icon(
                Icons.person_2_outlined,
                color: Theme.of(context).primaryColor,
                size: 20,
              )
            : null,
      ),
    ),
  );
}
