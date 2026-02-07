import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    /// Core colors
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    canvasColor: AppColors.lightSurface,

    /// Color scheme (VERY IMPORTANT)
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      error: AppColors.lightError,
      surface: AppColors.lightSurface,
    ),

    /// AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightPrimary,
      elevation: 0,
      centerTitle: true,
    ),

    /// Text
    textTheme: const TextTheme(
      headlineSmall: AppTextStyles.heading,
      bodyMedium: AppTextStyles.body,
      labelSmall: AppTextStyles.caption,
    ),

    /// Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.lightPrimary),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: const BorderSide(color: AppColors.lightPrimary),
      ),
    ),

    /// Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    ),

    /// Date Picker (your original + completed)
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: AppColors.lightBackground,
      weekdayStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.lightPrimary,
      ),
    ),

    /// Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.lightSecondary,
      thickness: 0.5,
    ),

    /// Icons
    iconTheme: const IconThemeData(color: AppColors.lightPrimary),

    /// Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    canvasColor: AppColors.darkSurface,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      error: AppColors.darkError,
      surface: AppColors.darkSurface,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkPrimary,
      elevation: 0,
      centerTitle: true,
    ),

    textTheme: TextTheme(
      headlineSmall: AppTextStyles.heading.copyWith(
        color: AppColors.darkPrimary,
      ),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.darkPrimary),
      labelSmall: AppTextStyles.caption.copyWith(
        color: AppColors.darkSecondary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.black,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    ),

    datePickerTheme: const DatePickerThemeData(
      backgroundColor: AppColors.darkBackground,
      weekdayStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.darkPrimary,
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.darkSecondary,
      thickness: 0.5,
    ),

    iconTheme: const IconThemeData(color: AppColors.darkPrimary),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
    ),
  );
}
