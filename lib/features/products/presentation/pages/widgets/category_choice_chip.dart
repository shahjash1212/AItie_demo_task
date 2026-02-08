import 'package:aitie_demo/constants/choice_chip.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryChoiceChipSection extends StatelessWidget {
  const CategoryChoiceChipSection({
    super.key,
    required this.categories,
    required this.displayProducts,
  });

  final List<String> categories;
  final List<ProductResponse> displayProducts;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip(
                        context: context,
                        label: 'All',
                        isSelected: state.selectedCategory == 'All',
                        onTap: () {
                          context.read<ProductBloc>().add(
                            const FilterByCategory(category: null),
                          );
                        },
                      ),
                      const GapW(8),
                      ...categories.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryChip(
                            context: context,
                            label:
                                category[0].toUpperCase() +
                                category.substring(1),
                            isSelected: state.selectedCategory == category,
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
              if (state.searchQuery != null || state.selectedCategory != 'All')
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
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      if (state.selectedCategory != 'All')
                        TextButton.icon(
                          onPressed: () {
                            context.read<ProductBloc>().add(
                              ClearFilters(isCategoryCleared: true),
                            );
                          },
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: const Text('Clear filters'),
                        ),
                    ],
                  ),
                ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
