import 'package:aitie_demo/features/home/widgets/bottom_nav_item.dart';
import 'package:aitie_demo/features/settings_debug_menu/cubit/feature_flag_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        child: Card(
          margin: EdgeInsets.only(bottom: 18, left: 10, right: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                BottomNavItem(
                  index: 0,
                  selectedIndex: navigationShell.currentIndex,
                  icon: Icons.storefront_outlined,
                  label: 'Products',
                  onTap: () {
                    context.read<FeatureFlagCubit>().resetTapCount();
                    navigationShell.goBranch(0);
                  },
                ),

                BottomNavItem(
                  index: 1,
                  selectedIndex: navigationShell.currentIndex,
                  icon: Icons.favorite,
                  label: 'Favorite',
                  activeColor: Colors.red,
                  onTap: () {
                    context.read<FeatureFlagCubit>().incrementTapCount(context);
                    navigationShell.goBranch(1);
                  },
                ),

                BottomNavItem(
                  index: 2,
                  selectedIndex: navigationShell.currentIndex,
                  icon: Icons.shopping_cart_outlined,
                  label: 'My Cart',
                  activeColor: Colors.green,
                  onTap: () {
                    context.read<FeatureFlagCubit>().resetTapCount();
                    navigationShell.goBranch(2);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
