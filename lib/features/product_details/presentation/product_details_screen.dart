import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductResponse product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? ''),
        actions: [
          IconButton(
            icon: Icon(
              (product.isFavorite ?? false)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: (product.isFavorite ?? false) ? Colors.red : null,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Smooth image transition
            Hero(
              tag: 'product_${product.id}',
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.image ?? '', fit: BoxFit.contain),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  // Category
                  Text(
                    product.category ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Text(
                    '₹ ${product.price}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating
                  if (product.rating != null)
                    Row(
                      children: [
                        RatingStars(rate: product.rating!.rate ?? 0),
                        const SizedBox(width: 8),
                        Text(
                          '(${product.rating!.count})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Description
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

      // Add to cart button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text('Add to Cart'),
        ),
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final num rate;

  const RatingStars({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rate.round() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}
