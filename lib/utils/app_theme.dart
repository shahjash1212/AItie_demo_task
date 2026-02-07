import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    canvasColor: AppColors.lightSurface,

    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      error: AppColors.lightError,
      surface: AppColors.lightSurface,
    ),
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

      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

      hintStyle: AppTextStyles.caption.copyWith(
        color: AppColors.lightSecondary,
      ),
      labelStyle: AppTextStyles.body.copyWith(color: AppColors.lightPrimary),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.lightSecondary),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.lightSecondary),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.lightError),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.lightError, width: 1.5),
      ),
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

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedColor: AppColors.lightPrimary.withValues(alpha: .15),
      disabledColor: AppColors.lightSecondary.withValues(alpha: 0.1),
      labelStyle: AppTextStyles.body.copyWith(color: AppColors.lightPrimary),
      secondaryLabelStyle: AppTextStyles.body.copyWith(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.lightPrimary, width: 0.8),
      ),
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

      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

      hintStyle: AppTextStyles.caption.copyWith(color: AppColors.darkSecondary),
      labelStyle: AppTextStyles.body.copyWith(color: AppColors.darkPrimary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.darkSecondary, width: .5),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.darkSecondary,
          width: 0.5,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 0.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.darkError),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppColors.darkError, width: 1.5),
      ),
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

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedColor: AppColors.darkPrimary.withValues(alpha: 0.25),
      disabledColor: AppColors.darkSecondary.withValues(alpha: 0.15),
      labelStyle: AppTextStyles.body.copyWith(color: AppColors.darkPrimary),
      secondaryLabelStyle: AppTextStyles.body.copyWith(color: Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.darkPrimary, width: 0.5),
      ),
    ),
  );
}
