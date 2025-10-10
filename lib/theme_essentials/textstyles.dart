import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTexttheme{
  AppTexttheme._();
  static TextTheme lightTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins().copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    ),
    headlineMedium: GoogleFonts.poppins().copyWith(
    fontSize: 28,
    color: Colors.black,
    fontWeight: FontWeight.w600
    ),
    headlineSmall: GoogleFonts.poppins().copyWith(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.w600
    ),
    bodyLarge:  GoogleFonts.poppins().copyWith(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold
    ),
    bodyMedium: GoogleFonts.poppins().copyWith(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w400
    ),
  bodySmall:  GoogleFonts.poppins().copyWith(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w300
  ),
 labelSmall: GoogleFonts.poppins().copyWith(
    fontSize: 14,
    color: AppColors.background,
    fontWeight: FontWeight.w300
  ),
  );
  static TextTheme darkTheme = TextTheme(
    bodyLarge:  GoogleFonts.poppins().copyWith(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold
    ),
    bodyMedium: GoogleFonts.poppins().copyWith(
    fontSize: 18,
    color: AppColors.secondary,
    fontWeight: FontWeight.bold
    ),
    bodySmall:  GoogleFonts.poppins().copyWith(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w300
  ),
   labelLarge: GoogleFonts.poppins().copyWith(
    fontSize: 14,
    color: AppColors.primary,
    fontWeight: FontWeight.w300
  ),
  labelMedium: GoogleFonts.poppins().copyWith(
    fontSize: 14,
    color: AppColors.secondary,
    fontWeight: FontWeight.w300
  ),
   labelSmall:  GoogleFonts.poppins().copyWith(
    fontSize: 12,
    color: AppColors.secondary,
    fontWeight: FontWeight.w300
  ),
  );
}
