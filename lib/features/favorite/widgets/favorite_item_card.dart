import 'package:aitie_demo/constants/app_network_image.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FavoriteItemCard extends StatelessWidget {
  final ProductResponse product;

  const FavoriteItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          await precacheImage(NetworkImage(product.image ?? ''), context);
          if (context.mounted) {
            GoRouter.of(context).pushNamed(
              RouteNames.productDetail,
              extra: {'product': product, 'isFromFavorites': true},
            );
          }
        },
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'favorite_product_${product.id}${product.image}',
                child: AppNetworkImage(imageUrl: product.image ?? ''),
              ),
              const GapW(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const GapH(4),
                    Text(
                      product.category ?? '',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const GapH(8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        const Spacer(),
                        if (product.rating != null) ...[
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const GapW(4),
                          Text(
                            '${product.rating!.rate}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24,
                    ),
                    onPressed: () {
                      _showRemoveFavoriteDialog(context, product);
                    },
                    tooltip: 'Remove from favorites',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveFavoriteDialog(
    BuildContext context,
    ProductResponse product,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from Favorites'),
        content: Text('Remove "${product.title}" from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                AddToFavorite(productId: product.id ?? 0),
              );
              GoRouter.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
