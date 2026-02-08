import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:aitie_demo/features/products/domain/repositories/product_repository.dart';
import 'package:aitie_demo/utils/feature_flag_service.dart';
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
  final FeatureFlagService featureFlagService;

  ProductBloc({
    required this.repository,
    required this.localDbService,
    required this.featureFlagService,
  }) : super(const ProductInitial()) {
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
      final isOfflineCachingEnabled =
          featureFlagService.isOfflineCachingEnabled;

      if (isOfflineCachingEnabled) {
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
      }

      final result = await repository.getAllProducts();

      if (result is RepoSuccess) {
        if (isOfflineCachingEnabled) {
          await localDbService.saveProducts(result.data);
        }
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
    final currentState = state is ProductsLoaded
        ? state as ProductsLoaded
        : null;
    final String? previousSearchQuery = currentState?.searchQuery;
    final String? previousSelectedCategory = currentState?.selectedCategory;

    emit(const ProductLoading());

    try {
      final result = await repository.getAllProducts();

      if (result is RepoSuccess) {
        List<ProductResponse> mergedProducts = result.data;

        if (featureFlagService.isOfflineCachingEnabled) {
          final localProducts = await localDbService.getAllProducts();

          final Map<int, ProductResponse> existingProductsMap = {
            for (var product in localProducts) product.id!: product,
          };

          mergedProducts = [];
          for (var newProduct in result.data) {
            final existingProduct = existingProductsMap[newProduct.id];

            if (existingProduct != null) {
              mergedProducts.add(
                newProduct.copyWith(
                  isFavorite: existingProduct.isFavorite,
                  isInCart: existingProduct.isInCart,
                  quantity: existingProduct.quantity,
                ),
              );
            } else {
              mergedProducts.add(newProduct);
            }
          }

          await localDbService.saveProducts(mergedProducts);
        }

        List<ProductResponse> filteredProducts = mergedProducts;

        if (previousSelectedCategory != null &&
            previousSelectedCategory != 'All') {
          filteredProducts = filteredProducts
              .where((product) => product.category == previousSelectedCategory)
              .toList();
        }

        if (previousSearchQuery != null && previousSearchQuery.isNotEmpty) {
          filteredProducts = filteredProducts
              .where(
                (product) =>
                    product.title?.toLowerCase().contains(
                      previousSearchQuery,
                    ) ??
                    false,
              )
              .toList();
        }

        add(
          GetAllFavoriteProducts(
            searchQuery: previousSearchQuery,
            selectedCategory: previousSelectedCategory,
          ),
        );
        add(
          GetCartProducts(
            searchQuery: previousSearchQuery,
            selectedCategory: previousSelectedCategory,
          ),
        );

        emit(
          ProductsLoaded(
            products: mergedProducts,
            filteredProducts: filteredProducts,
            searchQuery: previousSearchQuery,
            selectedCategory: previousSelectedCategory ?? 'All',
          ),
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
    if (!featureFlagService.isFavoritesEnabled) {
      emit(
        (state as ProductsLoaded).copyWith(favoriteStatus: FormzStatus.failure),
      );
      return;
    }

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

      if (featureFlagService.isOfflineCachingEnabled) {
        await localDbService.saveProducts(oldProducts);
      }

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
    if (!featureFlagService.isFavoritesEnabled) {
      emit(
        (state as ProductsLoaded).copyWith(
          favoriteProducts: [],
          favoriteProductStatus: FormzStatus.success,
        ),
      );
      return;
    }

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
          searchQuery: event.searchQuery,
          selectedCategory: event.selectedCategory,
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
    if (!featureFlagService.isCartEnabled) {
      emit(
        (state as ProductsLoaded).copyWith(
          cartProducts: [],
          cartStatus: FormzStatus.success,
        ),
      );
      return;
    }

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
          searchQuery: event.searchQuery,
          selectedCategory: event.selectedCategory,
        ),
      );
    } catch (e) {
      emit((state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure));
    }
  }

  Future<void> _addToCart(AddToCart event, Emitter<ProductState> emit) async {
    if (!featureFlagService.isCartEnabled) {
      emit((state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure));
      return;
    }

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

      if (featureFlagService.isOfflineCachingEnabled) {
        await localDbService.saveProducts(oldProducts);
      }

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
    if (!featureFlagService.isCartEnabled) {
      emit((state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure));
      return;
    }

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

      if (featureFlagService.isOfflineCachingEnabled) {
        await localDbService.saveProducts(oldProducts);
      }

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
    if (!featureFlagService.isCartEnabled) {
      emit((state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure));
      return;
    }

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

      if (featureFlagService.isOfflineCachingEnabled) {
        await localDbService.saveProducts(oldProducts);
      }

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
    if (!featureFlagService.isCartEnabled) {
      emit((state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure));
      return;
    }

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

      if (featureFlagService.isOfflineCachingEnabled) {
        await localDbService.saveProducts(oldProducts);
      }

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
    if (state is! ProductsLoaded) {
      return;
    }

    final currentState = state as ProductsLoaded;
    final query = event.query.toLowerCase().trim();

    List<ProductResponse> filtered = currentState.products;

    if (currentState.selectedCategory != 'All') {
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
        selectedCategory: currentState.selectedCategory,
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
    if (event.category != null) {
      filtered = filtered
          .where((product) => product.category == event.category)
          .toList();
    }

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
        searchQuery: currentState.searchQuery,
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
    final String? newSearchQuery = event.isSearchQueryCleared
        ? null
        : currentState.searchQuery;
    final String? newCategory = event.isCategoryCleared
        ? null
        : currentState.selectedCategory;

    List<ProductResponse> filtered = currentState.products;
    if (newCategory != null && newCategory != 'All') {
      filtered = filtered
          .where((product) => product.category == newCategory)
          .toList();
    }

    if (newSearchQuery != null && newSearchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (product) =>
                product.title?.toLowerCase().contains(newSearchQuery) ?? false,
          )
          .toList();
    }

    emit(
      currentState.copyWith(
        filteredProducts: filtered,
        searchQuery: newSearchQuery,
        selectedCategory: newCategory,
        clearFilterState: FormzStatus.success,
      ),
    );
  }
}
