import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/pages/widgets/empty_products.dart';
import 'package:aitie_demo/features/products/presentation/pages/widgets/product_container_widget.dart';
import 'package:flutter/material.dart';

class ProductsListView extends StatelessWidget {
  const ProductsListView({super.key, required this.displayProducts});

  final List<ProductResponse> displayProducts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4;
          childAspectRatio = 0.65;
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 3;
          childAspectRatio = 0.7;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
          childAspectRatio = 0.7;
        } else {
          crossAxisCount = 2;
          childAspectRatio = 0.68;
        }
        if (displayProducts.isEmpty) {
          return EmptyProducts();
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: displayProducts.length,
          itemBuilder: (context, index) {
            final product = displayProducts[index];
            return ProductContainer(product: product);
          },
        );
      },
    );
  }
}
