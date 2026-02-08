import 'package:aitie_demo/constants/app_common_widgets.dart';
import 'package:aitie_demo/constants/app_snack_bar.dart';
import 'package:aitie_demo/presentation/cart/widgets/cart_icon_button.dart';
import 'package:aitie_demo/data/product/models/product_response.dart';
import 'package:aitie_demo/presentation/products/bloc/product_bloc.dart';
import 'package:aitie_demo/presentation/products/pages/widgets/category_choice_chip.dart';
import 'package:aitie_demo/presentation/products/pages/widgets/product_error_widget.dart';
import 'package:aitie_demo/presentation/products/pages/widgets/product_search.dart';
import 'package:aitie_demo/presentation/products/pages/widgets/products_list.dart';
import 'package:aitie_demo/presentation/settings_debug_menu/cubit/feature_flag_cubit.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

  Future<bool> hasInternet() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: BlocBuilder<FeatureFlagCubit, FeatureFlagState>(
              builder: (context, featureState) {
                if (!featureState.isCartEnabled) {
                  return const SizedBox.shrink();
                }
                return BlocBuilder<ProductBloc, ProductState>(
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
                );
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

            final List<ProductResponse> displayProducts =
                state.filteredProducts.isEmpty &&
                    (state.searchQuery ?? '').isEmpty &&
                    state.selectedCategory == 'All'
                ? state.products
                : state.filteredProducts;

            return AppRefreshIndecator(
              onRefresh: () async {
                final isConnected = await hasInternet();

                if (!isConnected) {
                  if (context.mounted) {
                    showSnackBar(context, 'No internet connection');
                  }
                  return;
                }
                if (context.mounted) {
                  context.read<ProductBloc>().add(RefreshProductsEvent());
                }
              },
              child: Column(
                children: [
                  ProductsSearchBar(),
                  if (categories.isNotEmpty)
                    CategoryChoiceChipSection(
                      categories: categories,
                      displayProducts: displayProducts,
                    ),

                  Expanded(
                    child: ProductsListView(displayProducts: displayProducts),
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
