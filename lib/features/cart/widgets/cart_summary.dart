import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartSummary extends StatelessWidget {
  final List<ProductResponse> cartItems;

  const CartSummary({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    final subtotal = cartItems.fold<double>(
      0,
      (sum, item) => sum + ((item.price ?? 0) * (item.quantity ?? 1)),
    );
    final totalItems = cartItems.fold<int>(
      0,
      (sum, item) => sum + (item.quantity ?? 1),
    );

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal ($totalItems items)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '₹${subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const GapH(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showCheckoutDialog(context, subtotal),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🎉 Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary:'),
            const GapH(8),
            Text(
              'Total Amount: ₹${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const GapH(16),
            const Text(
              'This is a demo. No actual payment will be processed.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(ClearCart());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              GoRouter.of(context).pop();
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}
