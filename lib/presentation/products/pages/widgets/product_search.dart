import 'package:aitie_demo/presentation/products/bloc/product_bloc.dart';
import 'package:aitie_demo/utils/formz_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsSearchBar extends StatefulWidget {
  const ProductsSearchBar({super.key});

  @override
  State<ProductsSearchBar> createState() => _ProductsSearchBarState();
}

class _ProductsSearchBarState extends State<ProductsSearchBar> {
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductsLoaded) {
            if (state.clearFilterState.isSuccess) {
              if ((state.searchQuery ?? '').isEmpty) {
                searchController.clear();
              }
            }
          }
        },
        builder: (context, state) {
          if (state is ProductsLoaded) {
            if ((state.searchQuery ?? '').isNotEmpty) {
              searchController.text = state.searchQuery ?? '';
            }
            return TextField(
              controller: searchController,
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProducts(query: value));
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: (state.searchQuery ?? '').isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          context.read<ProductBloc>().add(
                            ClearFilters(isSearchQueryCleared: true),
                          );
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
