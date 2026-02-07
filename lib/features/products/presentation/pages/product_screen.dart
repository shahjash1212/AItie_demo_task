import 'package:aitie_demo/constants/app_common_widgets.dart';
import 'package:aitie_demo/constants/app_network_image.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/cart/widgets/cart_icon_button.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:aitie_demo/features/products/presentation/pages/widgets/product_error_widget.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProductBloc>().add(const LoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
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
            return const Center(child: AppLoader());
          } else if (state is ProductsLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Determine number of columns based on screen width
                int crossAxisCount;
                double childAspectRatio;

                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 4; // Large tablets/desktop
                  childAspectRatio = 0.65;
                } else if (constraints.maxWidth >= 800) {
                  crossAxisCount = 3; // Tablets
                  childAspectRatio = 0.7;
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 2; // Large phones/small tablets
                  childAspectRatio = 0.7;
                } else {
                  crossAxisCount = 2; // Phones
                  childAspectRatio = 0.68;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductContainer(product: product);
                  },
                );
              },
            );
          } else if (state is ProductError) {
            return ProductErrorWidget();
          }
          return const Column();
        },
      ),
    );
  }
}

class ProductContainer extends StatelessWidget {
  const ProductContainer({super.key, required this.product});

  final ProductResponse product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () async {
          await precacheImage(NetworkImage(product.image ?? ''), context);

          if (context.mounted) {
            GoRouter.of(
              context,
            ).pushNamed(RouteNames.productDetail, extra: product);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 30,
                child: Hero(
                  tag: 'product_${product.id}',
                  child: SizedBox(
                    width: double.infinity,
                    child: AppNetworkImage(
                      imageUrl: product.image ?? '',
                      size: 65,
                    ),
                  ),
                ),
              ),
              GapH(8),
              Expanded(
                flex: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      product.title ?? 'No Title',

                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const GapH(4),
                    // Rating
                    if (product.rating != null)
                      Row(
                        children: [
                          _buildStarRating(product.rating!.rate ?? 0),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.rating!.count ?? 0})',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    const GapH(4),
                    // Price
                    Text(
                      '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(num rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          // Full star
          return const Icon(Icons.star, size: 16, color: Colors.amber);
        } else if (index < rating) {
          // Half star
          return const Icon(Icons.star_half, size: 16, color: Colors.amber);
        } else {
          // Empty star
          return Icon(Icons.star_border, size: 16, color: Colors.grey[400]);
        }
      }),
    );
  }
}
