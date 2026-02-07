// product_bloc.dart
import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/domain/repositories/product_repository.dart';
import 'package:aitie_demo/utils/formz_status.dart';
import 'package:aitie_demo/utils/local_db_service.dart';
import 'package:aitie_demo/utils/repo_result_class.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  final LocalDbService localDbService;

  ProductBloc({required this.repository, required this.localDbService})
    : super(const ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddToFavorite>(_addToFavorite);
    on<AddToCart>(_addToCart);
    on<GetAllFavoriteProducts>(_getAllFavoriteProducts);
    on<GetCartProducts>(_getCartProducts);
    on<RemoveFromCart>(_removeFromCart);
    on<UpdateCartQuantity>(_updateCartQuantity);
    on<ClearCart>(_clearCart);
    on<ClearDatabaseEvent>(_clearDatabase);
    on<RefreshProductsEvent>(_refreshProducts);

    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final localProducts = await localDbService.getAllProducts();

      if (localProducts.isNotEmpty) {
        emit(
          ProductsLoaded(
            products: localProducts,
            filteredProducts: localProducts,
          ),
        );

        add(GetAllFavoriteProducts());
        add(GetCartProducts());
        return;
      }

      final result = await repository.getAllProducts();

      if (result is RepoSuccess) {
        await localDbService.saveProducts(result.data);
        emit(
          ProductsLoaded(products: result.data, filteredProducts: result.data),
        );
      } else if (result is RepoFailure) {
        emit(
          ProductError(
            message: result.errorMessage,
            statusCode: result.statusCode,
          ),
        );
      }
    } catch (e) {
      emit(
        ProductError(
          message: 'Failed to load products: ${e.toString()}',
          statusCode: null,
        ),
      );
    }
  }

  Future<void> _refreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      final result = await repository.getAllProducts();

      if (result is RepoSuccess) {
        await localDbService.clearDatabase();
        await localDbService.saveProducts(result.data);
        emit(ProductsLoaded(products: result.data));
      } else if (result is RepoFailure) {
        emit(
          ProductError(
            message: result.errorMessage,
            statusCode: result.statusCode,
          ),
        );
      }
    } catch (e) {
      emit(
        ProductError(
          message: 'Failed to refresh products: ${e.toString()}',
          statusCode: null,
        ),
      );
    }
  }

  Future<void> _clearDatabase(
    ClearDatabaseEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await localDbService.clearDatabase();
      emit(const ProductInitial());
    } catch (e) {
      if (state is ProductsLoaded) {
        emit(
          (state as ProductsLoaded).copyWith(
            favoriteStatus: FormzStatus.failure,
          ),
        );
      }
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

      // Update database
      await localDbService.saveProducts(oldProducts);

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
          return product.copyWith(isInCart: true, quantity: 1);
        }
        return product;
      }).toList();

      // Update database
      await localDbService.saveProducts(oldProducts);

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

  Future<void> _removeFromCart(
    RemoveFromCart event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(
        (state as ProductsLoaded).copyWith(cartStatus: FormzStatus.inProgress),
      );
      List<ProductResponse> oldProducts = List.from(
        (state as ProductsLoaded).products,
      );
      oldProducts = oldProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(isInCart: false, quantity: 0);
        }
        return product;
      }).toList();

      // Update database
      await localDbService.saveProducts(oldProducts);

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

  Future<void> _updateCartQuantity(
    UpdateCartQuantity event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(
        (state as ProductsLoaded).copyWith(cartStatus: FormzStatus.inProgress),
      );
      List<ProductResponse> oldProducts = List.from(
        (state as ProductsLoaded).products,
      );
      oldProducts = oldProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(quantity: event.quantity);
        }
        return product;
      }).toList();

      // Update database
      await localDbService.saveProducts(oldProducts);

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

  Future<void> _clearCart(ClearCart event, Emitter<ProductState> emit) async {
    try {
      emit(
        (state as ProductsLoaded).copyWith(cartStatus: FormzStatus.inProgress),
      );
      List<ProductResponse> oldProducts = List.from(
        (state as ProductsLoaded).products,
      );
      oldProducts = oldProducts.map((product) {
        return product.copyWith(isInCart: false, quantity: 0);
      }).toList();

      // Update database
      await localDbService.saveProducts(oldProducts);

      emit(
        (state as ProductsLoaded).copyWith(
          products: oldProducts,
          cartProducts: [],
          cartStatus: FormzStatus.success,
        ),
      );
    } catch (e) {
      emit((state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is! ProductsLoaded) return;

    final currentState = state as ProductsLoaded;
    final query = event.query.toLowerCase().trim();

    List<ProductResponse> filtered = currentState.products;

    if (currentState.selectedCategory != null) {
      filtered = filtered
          .where((product) => product.category == currentState.selectedCategory)
          .toList();
    }

    if (query.isNotEmpty) {
      filtered = filtered
          .where(
            (product) => product.title?.toLowerCase().contains(query) ?? false,
          )
          .toList();
    }

    emit(
      currentState.copyWith(
        filteredProducts: filtered,
        searchQuery: query.isEmpty ? null : query,
      ),
    );
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductState> emit,
  ) async {
    if (state is! ProductsLoaded) return;

    final currentState = state as ProductsLoaded;
    List<ProductResponse> filtered = currentState.products;

    // Apply category filter
    if (event.category != null) {
      filtered = filtered
          .where((product) => product.category == event.category)
          .toList();
    }

    // Re-apply search query if exists
    if (currentState.searchQuery != null &&
        currentState.searchQuery!.isNotEmpty) {
      filtered = filtered
          .where(
            (product) =>
                product.title?.toLowerCase().contains(
                  currentState.searchQuery!,
                ) ??
                false,
          )
          .toList();
    }

    emit(
      currentState.copyWith(
        filteredProducts: filtered,
        selectedCategory: event.category,
      ),
    );
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<ProductState> emit,
  ) async {
    if (state is! ProductsLoaded) return;

    final currentState = state as ProductsLoaded;
    emit(
      currentState.copyWith(
        filteredProducts: currentState.products,
        searchQuery: null,
        selectedCategory: null,
      ),
    );
  }
}
