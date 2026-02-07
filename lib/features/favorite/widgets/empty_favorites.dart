import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey.shade300),
          const GapH(16),
          Text(
            'No favorites yet',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
          const GapH(8),
          Text(
            'Start adding products to your favorites',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const GapH(24),
          ElevatedButton.icon(
            onPressed: () => GoRouter.of(context).goNamed(RouteNames.product),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}
