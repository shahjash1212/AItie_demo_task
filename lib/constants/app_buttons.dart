import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_common_widgets.dart';
import 'package:aitie_demo/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppButtonBorder extends StatelessWidget {
  const AppButtonBorder({
    super.key,
    required this.onTap,
    required this.text,
    this.height,
    this.textStyle,
    this.isLoading = false,
  });

  final Function onTap;
  final String text;
  final TextStyle? textStyle;
  final double? height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLoading) return;
        onTap();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: height ?? 48,
        alignment: Alignment.center,

        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColor.kFFFFFF,
          border: Border.all(color: AppColor.k0D0D0D, width: 1.0),
        ),
        child: isLoading
            ? AppLoader(color: AppColor.k0D0D0D, size: 16)
            : Text(text, style: AppStyles.kGilroyBold),
      ),
    );
  }
}
