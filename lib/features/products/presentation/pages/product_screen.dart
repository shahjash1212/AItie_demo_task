import 'package:aitie_demo/constants/app_common_widgets.dart';
import 'package:aitie_demo/features/cart/widgets/cart_icon_button.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:aitie_demo/features/products/presentation/pages/widgets/product_container_widget.dart';
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
          } // Now create the UI with search and category filters
          else if (state is ProductsLoaded) {
            // Extract unique categories
            final categories =
                state.products
                    .map((p) => p.category)
                    .whereType<String>()
                    .toSet()
                    .toList()
                  ..sort();

            // Use filtered products or all products
            final displayProducts =
                state.filteredProducts.isEmpty &&
                    state.searchQuery == null &&
                    state.selectedCategory == null
                ? state.products
                : state.filteredProducts;

            return AppRefreshIndecator(
              onRefresh: () async {
                context.read<ProductBloc>().add(RefreshProductsEvent());
              },
              child: Column(
                children: [
                  ProductsSearchBar(),

                  if (categories.isNotEmpty)
                    if (categories.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // "All" chip
                              _buildCategoryChip(
                                context: context,
                                label: 'All',
                                isSelected: state.selectedCategory == null,
                                onTap: () {
                                  context.read<ProductBloc>().add(
                                    const FilterByCategory(category: null),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              // Category chips
                              ...categories.map(
                                (category) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _buildCategoryChip(
                                    context: context,
                                    label:
                                        category[0].toUpperCase() +
                                        category.substring(1),
                                    isSelected:
                                        state.selectedCategory == category,
                                    onTap: () {
                                      context.read<ProductBloc>().add(
                                        FilterByCategory(category: category),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                  if (state.searchQuery != null ||
                      state.selectedCategory != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${displayProducts.length} products found',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          if (state.searchQuery != null ||
                              state.selectedCategory != null)
                            TextButton.icon(
                              onPressed: () {
                                context.read<ProductBloc>().add(ClearFilters());
                              },
                              icon: const Icon(Icons.clear_all, size: 18),
                              label: const Text('Clear filters'),
                            ),
                        ],
                      ),
                    ),

                  // Product Grid
                  Expanded(
                    child: LayoutBuilder(
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

                        // Empty state
                        if (displayProducts.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No products found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () {
                                    context.read<ProductBloc>().add(
                                      ClearFilters(),
                                    );
                                  },
                                  child: const Text('Clear filters'),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                    ),
                  ),
                ],
              ),
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

class ProductsSearchBar extends StatelessWidget {
  const ProductsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            return TextField(
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProducts(query: value));
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: state.searchQuery != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          context.read<ProductBloc>().add(ClearFilters());
                        },
                      )
                    : null,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

// Add this helper method outside the build method or as a separate widget
Widget _buildCategoryChip({
  required BuildContext context,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).cardColor,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
