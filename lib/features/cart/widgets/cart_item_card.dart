import 'package:aitie_demo/constants/app_network_image.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/cart/widgets/cart_icon_button.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final ProductResponse product;

  const CartItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNetworkImage(imageUrl: product.image ?? ''),
            const GapW(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${product.price}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.cancel, size: 20),
                  onPressed: () {
                    // context.read<ProductBloc>().add(
                    //   RemoveFromCart(productId: product.id ?? 0),
                    // );
                  },
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                ),
                GapH(16),
                QuantityControl(product: product),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuantityControl extends StatelessWidget {
  final ProductResponse product;

  const QuantityControl({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final quantity = product.quantity ?? 1;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconButton(icon: Icons.remove, onPressed: () {}),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('$quantity'),
          ),
          AppIconButton(icon: Icons.add, onPressed: () {}),
        ],
      ),
    );
  }
}
