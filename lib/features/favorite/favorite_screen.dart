import 'package:aitie_demo/features/cart/widgets/cart_icon_button.dart';
import 'package:aitie_demo/features/favorite/widgets/empty_favorites.dart';
import 'package:aitie_demo/features/favorite/widgets/favorite_item_card.dart';
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
          } else if (state is ProductsLoaded) {
            if (state.favoriteProducts.isEmpty) {
              return EmptyFavorites();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: state.favoriteProducts.length,
              itemBuilder: (context, index) {
                return FavoriteItemCard(product: state.favoriteProducts[index]);
              },
            );
          } else {
            return ProductErrorWidget();
          }
        },
      ),
    );
  }
}
