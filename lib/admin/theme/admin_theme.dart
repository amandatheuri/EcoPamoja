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
    textTheme: AppTextTheme.lightTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    textTheme: AppTextTheme.darkTheme,
  );
}
