import 'package:aitie_demo/constants/app_network_image.dart';
import 'package:aitie_demo/constants/app_snack_bar.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/cart/widgets/cart_icon_button.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  const GapH(4),
                  Text(
                    product.category ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  const GapH(8),
                  Text(
                    '\$${product.price}',
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
                    context.read<ProductBloc>().add(
                      RemoveFromCart(productId: product.id ?? 0),
                    );
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
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          int quantity =
              state.products
                  .firstWhere((element) => element.id == product.id)
                  .quantity ??
              0;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  icon: Icons.remove,
                  onPressed: () {
                    if (quantity > 1) {
                      context.read<ProductBloc>().add(
                        UpdateCartQuantity(
                          productId: product.id ?? 0,
                          quantity: quantity - 1,
                        ),
                      );
                    } else {
                      showErrorSnackBar(
                        context,
                        'Quantity cannot be less than 1',
                      );
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('$quantity'),
                ),
                AppIconButton(
                  icon: Icons.add,
                  onPressed: () {
                    context.read<ProductBloc>().add(
                      UpdateCartQuantity(
                        productId: product.id ?? 0,
                        quantity: quantity + 1,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
