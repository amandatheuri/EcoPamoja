import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle title = GoogleFonts.slacksideOne(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );
  static TextStyle subHeading = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );
  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
  );
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );
}
