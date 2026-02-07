import 'package:aitie_demo/features/products/domain/repositories/product_repository.dart';
import 'package:aitie_demo/utils/repo_result_class.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(const ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<LoadProductDetailsEvent>(_onLoadProductDetails);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }

  /// Load all products
  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await repository.getAllProducts();

    if (result is RepoSuccess) {
      emit(ProductsLoaded(products: result.data));
    } else if (result is RepoFailure) {
      emit(
        ProductError(
          message: result.errorMessage,
          statusCode: result.statusCode,
        ),
      );
    }
  }

  /// Load product details by ID
  Future<void> _onLoadProductDetails(
    LoadProductDetailsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await repository.getProductDetails(
      productId: event.productId,
    );

    if (result is RepoSuccess) {
      emit(ProductDetailsLoaded(product: result.data));
    } else if (result is RepoFailure) {
      emit(
        ProductError(
          message: result.errorMessage,
          statusCode: result.statusCode,
        ),
      );
    }
  }

  /// Refresh products (similar to load, but might be different in the future)
  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await repository.getAllProducts();

    if (result is RepoSuccess) {
      emit(ProductsLoaded(products: result.data));
    } else if (result is RepoFailure) {
      emit(
        ProductError(
          message: result.errorMessage,
          statusCode: result.statusCode,
        ),
      );
    }
  }
}
