import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/domain/repositories/product_repository.dart';
import 'package:aitie_demo/utils/formz_status.dart';
import 'package:aitie_demo/utils/repo_result_class.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(const ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddToFavorite>(_addToFavorite);
  }
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

  Future<void> _addToFavorite(
    AddToFavorite event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(
        (state as ProductsLoaded).copyWith(
          favoriteStatus: FormzStatus.inProgress,
        ),
      );
      List<ProductResponse> oldProducts = List.from(
        (state as ProductsLoaded).products,
      );
      oldProducts = oldProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(isFavorite: !(product.isFavorite ?? false));
        }
        return product;
      }).toList();

      emit(
        (state as ProductsLoaded).copyWith(
          products: oldProducts,
          favoriteStatus: FormzStatus.success,
        ),
      );
    } catch (e) {
      emit(
        (state as ProductsLoaded).copyWith(favoriteStatus: FormzStatus.failure),
      );
    }
  }
}
