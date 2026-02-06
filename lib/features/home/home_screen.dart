import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_images.dart';
import 'package:aitie_demo/features/home/widgets/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [Expanded(child: navigationShell)]),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: AppColors.darkBackground),
          child: Row(
            children: [
              BottomNavItem(
                index: 0,
                selectedIndex: navigationShell.currentIndex,
                label: 'Dashboard',
                onTap: () => navigationShell.goBranch(0),
                svgEnable: AppImages.favorite,
                svgDisable: AppImages.favorite,
              ),
              BottomNavItem(
                index: 1,
                selectedIndex: navigationShell.currentIndex,
                label: 'Spend',
                onTap: () => navigationShell.goBranch(1),
                svgEnable: AppImages.favorite,
                svgDisable: AppImages.favorite,
              ),
              BottomNavItem(
                index: 2,
                selectedIndex: navigationShell.currentIndex,
                label: 'Insights',
                onTap: () => navigationShell.goBranch(2),
                svgEnable: AppImages.favorite,
                svgDisable: AppImages.favorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
