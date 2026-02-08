import 'package:aitie_demo/presentation/product_details/product_details_screen.dart';
import 'package:aitie_demo/presentation/products/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailDeepLinkScreen extends StatelessWidget {
  final int productId;
  final bool isFromFavorites;

  const ProductDetailDeepLinkScreen({
    super.key,
    required this.productId,
    required this.isFromFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        // Handle loading state
        if (state is ProductLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ProductError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        LoadSingleProductEvent(productId: productId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Handle single product loaded state (from deep link)
        if (state is SingleProductLoaded) {
          return ProductDetailScreen(
            product: state.product,
            isFromFavorites: isFromFavorites,
          );
        }

        // Handle products loaded state (if user navigated to products list first)
        if (state is ProductsLoaded) {
          try {
            final product = state.products.firstWhere((p) => p.id == productId);
            return ProductDetailScreen(
              product: product,
              isFromFavorites: isFromFavorites,
            );
          } catch (_) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Product not found')),
            );
          }
        }

        // Fallback
        return Scaffold(
          appBar: AppBar(title: const Text('Loading...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
