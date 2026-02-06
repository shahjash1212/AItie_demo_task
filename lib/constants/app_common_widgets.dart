import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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

class AppsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDark;
  final Widget? leading;
  final double? elevation;
  final VoidCallback? onBack;

  final List<Widget> actions;

  const AppsAppBar({
    super.key,
    required this.title,
    this.isDark = false,
    this.leading,
    this.elevation,
    this.onBack,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDark ? AppColors.lightSurface : AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      title: Text(title),
      leading: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (onBack == null) {
            GoRouter.of(context).pop();
          }
          if (onBack != null) {
            onBack?.call();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: SvgPicture.asset(
            AppImages.leftArrow,
            colorFilter: ColorFilter.mode(
              isDark ? AppColors.lightBackground : AppColors.darkBackground,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
