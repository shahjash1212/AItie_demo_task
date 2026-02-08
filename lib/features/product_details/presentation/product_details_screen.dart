import 'package:aitie_demo/constants/app_network_image.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductResponse product;
  final bool isFromFavorites;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.isFromFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? ''),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductsLoaded) {
                bool isFavorite =
                    ((state).products
                        .firstWhere((element) => element.id == product.id)
                        .isFavorite ??
                    false);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    context.read<ProductBloc>().add(
                      AddToFavorite(productId: product.id ?? 0),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: isFromFavorites
                  ? 'favorite_product_${product.id}${product.image}'
                  : 'product_${product.id}${product.image}',
              child: AspectRatio(
                aspectRatio: 1,
                child: AppNetworkImage(imageUrl: product.image ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const GapH(8),
                  Text(
                    product.category ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const GapH(12),
                  Text(
                    '\$ ${product.price}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const GapH(12),

                  if (product.rating != null)
                    Row(
                      children: [
                        RatingStars(rate: product.rating!.rate ?? 0),
                        const GapW(8),
                        Text(
                          '(${product.rating!.count})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),

                  const GapH(16),
                  Text(
                    product.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoaded) {
              final currentProduct = state.products.firstWhere(
                (element) => element.id == product.id,
                orElse: () => product,
              );
              bool isInCart = currentProduct.isInCart ?? false;
              return ElevatedButton(
                onPressed: () {
                  if (isInCart) {
                    GoRouter.of(context).goNamed(RouteNames.cart);
                  } else {
                    context.read<ProductBloc>().add(
                      AddToCart(productId: product.id ?? 0),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: isInCart
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isInCart) ...[
                      const Icon(Icons.shopping_cart_outlined, size: 18),
                      const GapW(8),
                    ],
                    Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final num rate;
  final bool isSmall;

  const RatingStars({super.key, required this.rate, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rate.round() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: isSmall ? 11 : 20,
        );
      }),
    );
  }
}
