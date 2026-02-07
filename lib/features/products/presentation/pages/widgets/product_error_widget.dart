import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/errors/error_screen.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductErrorWidget extends StatelessWidget {
  const ProductErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please try feteching data again'),
          const GapH(16),
          RetryButton(
            onRetry: () {
              context.read<ProductBloc>().add(const LoadProductsEvent());
            },
          ),
        ],
      ),
    );
  }
}
