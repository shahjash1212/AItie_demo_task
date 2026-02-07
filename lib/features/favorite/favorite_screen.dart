import 'package:aitie_demo/constants/app_network_image.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/cart/widgets/cart_icon_button.dart';
import 'package:aitie_demo/features/errors/error_screen.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:aitie_demo/features/products/presentation/pages/widgets/product_error_widget.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductsLoaded) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AppIconButton(
                        onPressed: () =>
                            GoRouter.of(context).goNamed(RouteNames.cart),
                        icon: Icons.shopping_cart_outlined,
                      ),
                      if (state.cartProducts.isNotEmpty)
                        Positioned(
                          right: 5,
                          top: 5,
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.red,
                          ),
                        ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsLoaded) {
            if (state.favoriteProducts.isEmpty) {
              return _buildEmptyFavorites(context);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.favoriteProducts.length,
              itemBuilder: (context, index) {
                return _FavoriteItemCard(
                  product: state.favoriteProducts[index],
                );
              },
            );
          }

          if (state is ProductError) {
            return ProductErrorWidget();
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyFavorites(BuildContext context) {
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

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
          const GapH(16),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
          const GapH(24),
          RetryButton(
            onRetry: () {
              context.read<ProductBloc>().add(const LoadProductsEvent());
            },
          ),
        ],
      ),
    );
  }

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text(
          'Are you sure you want to remove all products from favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _clearAllFavorites(context);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _clearAllFavorites(BuildContext context) {
    final currentState = context.read<ProductBloc>().state;
    if (currentState is ProductsLoaded) {
      for (var product in currentState.favoriteProducts) {
        context.read<ProductBloc>().add(
          AddToFavorite(productId: product.id ?? 0),
        );
      }
    }
  }
}

// Favorite Item Card Widget
class _FavoriteItemCard extends StatelessWidget {
  final ProductResponse product;

  const _FavoriteItemCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          GoRouter.of(
            context,
          ).goNamed(RouteNames.productDetail, extra: product);
        },
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Hero(
                tag: 'product_${product.id}',
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
                          '₹${product.price}',
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

              // Remove from Favorites Button
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
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.title} removed from favorites'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        AddToFavorite(productId: product.id ?? 0),
                      );
                    },
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
