import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppTexttheme.lightTheme,
    iconTheme: const IconThemeData(color: AppColors.lightThemeContrast),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        textStyle: AppTexttheme.lightTheme.bodyLarge,
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      ),
    ),
    )
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Color(0xff0F0F0F),
    textTheme: AppTexttheme.darkTheme,
    iconTheme: const IconThemeData(color: AppColors.secondary),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.secondary,
        backgroundColor: AppColors.primary,
        textStyle: AppTexttheme.darkTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
      ),
    ),
  );
}
