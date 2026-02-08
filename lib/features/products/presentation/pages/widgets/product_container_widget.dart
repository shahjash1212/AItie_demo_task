import 'package:aitie_demo/constants/app_network_image.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/product_details/presentation/product_details_screen.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            GoRouter.of(context).pushNamed(
              RouteNames.productDetail,
              extra: {'product': product, 'isFromFavorites': false},
            );
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
                  tag: 'product_${product.id}${product.image}',
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
                          RatingStars(
                            rate: product.rating!.rate ?? 0,
                            isSmall: true,
                          ),
                          const GapW(4),
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
}
