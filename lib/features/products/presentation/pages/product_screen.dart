import 'package:aitie_demo/constants/app_common_widgets.dart';
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/products/data/data_sources/product_remote_data_source.dart';
import 'package:aitie_demo/features/products/data/repositories/product_repository_impl.dart';
import 'package:aitie_demo/features/products/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = ProductRemoteDataSourceImpl();
    final repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final productBloc = ProductBloc(repository: repository);

    return BlocProvider<ProductBloc>(
      create: (context) => productBloc..add(const LoadProductsEvent()),
      child: const _ProductScreenContent(),
    );
  }
}

class _ProductScreenContent extends StatelessWidget {
  const _ProductScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppsAppBar(title: 'Products'),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: AppLoader());
          } else if (state is ProductsLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  title: Text(product.title ?? 'No Title'),
                  subtitle: Text('\$${product.price}'),
                  leading: product.image != null
                      ? Image.network(product.image!, width: 50, height: 50)
                      : null,
                  onTap: () {
                    context.read<ProductBloc>().add(
                      LoadProductDetailsEvent(productId: product.id ?? 0),
                    );
                  },
                );
              },
            );
          } else if (state is ProductDetailsLoaded) {
            final product = state.product;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.image != null) Image.network(product.image!),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title ?? 'No Title',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const GapH(8),
                        Text(
                          '\$${product.price}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const GapH(16),
                        Text(product.description ?? 'No description'),
                        const GapH(16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductBloc>().add(
                              const LoadProductsEvent(),
                            );
                          },
                          child: const Text('Back to Products'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
