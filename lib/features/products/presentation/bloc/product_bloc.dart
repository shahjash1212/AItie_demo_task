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
    on<AddToCart>(_addToCart);
    on<GetAllFavoriteProducts>(_getAllFavoriteProducts);
    on<GetCartProducts>(_getCartProducts);
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
      add(GetAllFavoriteProducts());
    } catch (e) {
      emit(
        (state as ProductsLoaded).copyWith(favoriteStatus: FormzStatus.failure),
      );
    }
  }

  Future<void> _addToCart(AddToCart event, Emitter<ProductState> emit) async {
    try {
      emit(
        (state as ProductsLoaded).copyWith(cartStatus: FormzStatus.inProgress),
      );
      List<ProductResponse> oldProducts = List.from(
        (state as ProductsLoaded).products,
      );
      oldProducts = oldProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(isInCart: !(product.isInCart ?? false));
        }
        return product;
      }).toList();

      emit(
        (state as ProductsLoaded).copyWith(
          products: oldProducts,
          cartStatus: FormzStatus.success,
        ),
      );
      add(GetCartProducts());
    } catch (e) {
      emit((state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure));
    }
  }

  Future<void> _getAllFavoriteProducts(
    GetAllFavoriteProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(
        (state as ProductsLoaded).copyWith(
          favoriteProductStatus: FormzStatus.inProgress,
        ),
      );
      List<ProductResponse> oldProducts = List.from(
        (state as ProductsLoaded).products,
      );
      List<ProductResponse> favoriteProducts = oldProducts
          .where((product) => product.isFavorite == true)
          .toList();
      emit(
        (state as ProductsLoaded).copyWith(
          favoriteProducts: favoriteProducts,
          favoriteProductStatus: FormzStatus.success,
        ),
      );
    } catch (e) {
      emit(
        (state as ProductsLoaded).copyWith(
          favoriteProductStatus: FormzStatus.failure,
        ),
      );
    }
  }

  Future<void> _getCartProducts(
    GetCartProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(
        (state as ProductsLoaded).copyWith(cartStatus: FormzStatus.inProgress),
      );
      List<ProductResponse> oldProducts = List.from(
        (state as ProductsLoaded).products,
      );
      List<ProductResponse> inCartProducts = oldProducts
          .where((product) => product.isInCart == true)
          .toList();
      emit(
        (state as ProductsLoaded).copyWith(
          cartProducts: inCartProducts,
          cartStatus: FormzStatus.success,
        ),
      );
    } catch (e) {
      emit((state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure));
    }
  }
}
