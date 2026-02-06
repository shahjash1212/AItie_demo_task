import 'package:aitie_demo/constants/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String svgEnable;
  final String svgDisable;
  final String label;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.svgEnable,
    required this.svgDisable,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(isActive ? svgEnable : svgDisable),
            const GapH(2),
            Text(label),
          ],
        ),
      ),
    );
  }
}
