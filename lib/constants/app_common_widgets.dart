import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_images.dart';
import 'package:aitie_demo/constants/app_styles.dart';
import 'package:aitie_demo/constants/app_styles.dart';
import 'package:aitie_demo/constants/gap.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';


class AppDecoration {
  static BoxDecoration buttonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: const LinearGradient(
      begin: Alignment(-0.83, -0.71),
      end: Alignment(0.99, 0.31),
      colors: [AppColor.k0D0D0D, AppColor.k0D0D0D],
      stops: [0, 1],
      transform: GradientRotation(45),
    ),
  );
}

class AppContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final bool showContainer;
  final bool isWhiteTopContainer;
  final bool noBorderRadius;
  final Color? backgroundColor;

  const AppContainer({
    super.key,
    required this.child,
    this.color = AppColor.k0D0D0D,
    this.padding = const EdgeInsets.symmetric(horizontal: 45, vertical: 25),
    this.showContainer = true,
    this.isWhiteTopContainer = false,
    this.noBorderRadius = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showContainer)
          Container(
            padding: EdgeInsets.zero,
            height: 10,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              boxShadow: [
                if (isWhiteTopContainer)
                  BoxShadow(
                    color: AppColor.k000000.withValues(alpha: .25),
                    offset: Offset(0, -1),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
              ],
              color:
                  backgroundColor ??
                  (isWhiteTopContainer
                      ? AppColor.kFFFFFF.withValues(alpha: .75)
                      : AppColor.k000000),
              borderRadius: noBorderRadius
                  ? BorderRadius.zero
                  : BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
            ),
          ),
        Container(
          width: double.maxFinite,
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: noBorderRadius
                ? BorderRadius.zero
                : BorderRadius.circular(15),
          ),
          child: child,
        ),
      ],
    );
  }
}

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
      backgroundColor: isDark ? AppColor.k0D0D0D : AppColor.kFFFFFF,
      color: isDark ? AppColor.kFFFFFF : AppColor.k0D0D0D,
      onRefresh: onRefresh,
      child: child,
    );
  }
}

class AppTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;
  final bool isDark;
  final bool isLoading;
  final Widget? child;

  const AppTextButton({
    super.key,
    required this.onTap,
    this.text,
    this.isDark = false,
    this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColor.k0D0D0D : AppColor.kFFFFFF,
          border: Border.all(
            color: isDark ? AppColor.k3D3D3D : AppColor.k0D0D0D,
            width: 1.0,
          ),
        ),
        width: double.maxFinite,
        height: 48,
        alignment: Alignment.center,
        child: isLoading
            ? AppLoader(color: isDark ? AppColor.kFFFFFF : AppColor.k0D0D0D)
            : child ??
                  Text(
                    text ?? '',
                    style: AppStyles.kGilroyBold.copyWith(
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColor.kFFFFFF : AppColor.k0D0D0D,
                    ),
                  ),
      ),
    );
  }
}

class AppTextNImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;
  final String svg;
  final bool isSvgFirst;
  final double? width;
  final double? height;
  final bool isBorderButton;
  final Color? borderColor;
  final bool isSmallButton;
  final bool showLoading;
  final EdgeInsets? padding;
  final bool isDark;

  const AppTextNImageButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color = AppColor.k0D0D0D,
    this.svg = AppImages.rightArrow,
    this.isSvgFirst = false,
    this.isBorderButton = false,
    this.width,
    this.height,
    this.borderColor,
    this.isSmallButton = false,
    this.showLoading = false,
    this.isDark = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: InkWell(
        onTap: showLoading ? null : onTap,
        child: Container(
          height: height ?? 48,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: isBorderButton
                ? Border.all(color: borderColor ?? AppColor.k0D0D0D, width: 1.0)
                : null,
            color: isBorderButton ? Colors.transparent : color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showLoading) ...[
                const AppLoader(),
              ] else ...[
                if (isSvgFirst) ...[SvgPicture.asset(svg), GapW(10)],
                Text(
                  text,
                  style: isSmallButton
                      ? AppStyles.kGilroyBold.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColor.kFFFFFF,
                        )
                      : AppStyles.kGilroyBold.copyWith(
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? AppColor.k0D0D0D
                              : isBorderButton
                              ? borderColor ?? AppColor.k0D0D0D
                              : AppColor.kFFFFFF,
                        ),
                ),
                if (!isSvgFirst) ...[
                  GapW(10),
                  SvgPicture.asset(
                    svg,
                    width: isSmallButton ? 12 : null,
                    colorFilter: ColorFilter.mode(
                      isDark ? AppColor.k0D0D0D : AppColor.kFFFFFF,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}


class CustomSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({super.key, this.initialValue = false, this.onChanged});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isOn = !isOn);
        widget.onChanged?.call(isOn);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.k3D3D3D),
          color: isOn ? Colors.white : AppColor.k161616,
          borderRadius: BorderRadius.circular(30),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.66,
                  ), // Adjust the opacity as needed
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
              color: isOn ? AppColor.kA0B22D : AppColor.k3D3D3D,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.color = AppColor.kFFFFFF, this.size = 23});
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
      backgroundColor: isDark ? AppColor.k0D0D0D : AppColor.kFFFFFF,
      surfaceTintColor: Colors.transparent,
      title: Text(
        title,
        style: AppStyles.kPPCirkaMedium.copyWith(
          color: isDark ? AppColor.kFFFFFF : AppColor.k0D0D0D,
        ),
      ),
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
              isDark ? AppColor.kFFFFFF : AppColor.k0D0D0D,
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
