import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    primaryColor: AppColor.k0D0D0D,
    scaffoldBackgroundColor: AppColor.k000000,
    appBarTheme: const AppBarTheme(backgroundColor: AppColor.k0D0D0D),
    datePickerTheme: DatePickerThemeData(
      /// Weekday labels (M T W T F S S)
      weekdayStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColor.k0D0D0D,
      ),

      /// Day numbers (1,2,3...)
      dayStyle: AppStyles.kGilroyBold.copyWith(
        fontSize: 14,
        color: AppColor.k0D0D0D,
      ),

      /// Year text (when year picker is shown)
      yearStyle: AppStyles.kGilroyBold.copyWith(
        fontSize: 14,
        color: AppColor.k0D0D0D,
      ),
    ),
  );
}
