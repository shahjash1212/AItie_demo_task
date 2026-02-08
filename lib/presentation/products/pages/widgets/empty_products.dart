import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/presentation/products/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyProducts extends StatelessWidget {
  const EmptyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const GapH(16),
          Text(
            'No products found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const GapH(8),
          TextButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                ClearFilters(
                  isCategoryCleared: true,
                  isSearchQueryCleared: true,
                ),
              );
            },
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}
