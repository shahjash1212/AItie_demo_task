// features/products/presentation/screens/cart_screen.dart

import 'package:aitie_demo/features/cart/widgets/cart_item_card.dart';
import 'package:aitie_demo/features/cart/widgets/cart_summary.dart';
import 'package:aitie_demo/features/cart/widgets/empty_cart.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductsLoaded) {
                final cartItems = state.products
                    .where((product) => product.isInCart == true)
                    .toList();

                if (cartItems.isNotEmpty) {
                  return TextButton.icon(
                    onPressed: () => _showClearCartDialog(context),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsLoaded) {
            final cartItems = state.products
                .where((product) => product.isInCart == true)
                .toList();

            if (cartItems.isEmpty) {
              return EmptyCart();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemCard(product: cartItems[index]);
                    },
                  ),
                ),
                CartSummary(cartItems: cartItems),
              ],
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductBloc>().add(ClearCart());
              GoRouter.of(context).pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
