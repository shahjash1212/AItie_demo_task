import 'package:aitie_demo/constants/app_common_widgets.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/products/presentation/bloc/product_bloc.dart';
import 'package:aitie_demo/features/products/presentation/pages/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppsAppBar(title: 'Favorites'),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: AppLoader());
          } else if (state is ProductsLoaded) {
            return ListView.builder(
              itemCount: state.favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = state.favoriteProducts[index];
                return ProductContainer(product: product);
              },
            );
          } else if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const GapH(16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        const LoadProductsEvent(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Column();
        },
      ),
    );
  }
}
