import 'package:aitie_demo/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppRefreshIndecator extends StatelessWidget {
  const AppRefreshIndecator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.isDark = false,
  });
  final Future<void> Function() onRefresh;
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      color: isDark ? AppColors.lightBackground : AppColors.darkBackground,
      onRefresh: onRefresh,
      child: child,
    );
  }
}

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.color = AppColors.lightBackground,
    this.size = 23,
  });
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: 3, color: color),
    );
  }
}
