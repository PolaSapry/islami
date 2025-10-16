import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.blackColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.primaryDark)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: AppColors.whiteColor,
          unselectedItemColor: AppColors.blackColor,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          // selectedLabelStyle:
          //     AppTheme.darkTheme.textTheme.bodySmall?.copyWith(fontSize: 8),
          backgroundColor: AppColors.primaryDark),
      textTheme: TextTheme(
          headlineLarge: GoogleFonts.elMessiri(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor),
          bodyLarge: GoogleFonts.elMessiri(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor),
          bodySmall: GoogleFonts.elMessiri(
              fontSize: 12, color: AppColors.whiteColor)));
}
