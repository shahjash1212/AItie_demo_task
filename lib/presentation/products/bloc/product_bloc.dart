import 'package:aitie_demo/data/product/models/product_response.dart';
import 'package:aitie_demo/domain/product/repositories/product_repository.dart';
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
    on<LoadSingleProductEvent>(_onLoadSingleProduct);
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
      if (state is ProductsLoaded) {
        emit(
          (state as ProductsLoaded).copyWith(
            favoriteStatus: FormzStatus.failure,
          ),
        );
      } else if (state is SingleProductLoaded) {
        emit(
          (state as SingleProductLoaded).copyWith(
            favoriteStatus: FormzStatus.failure,
          ),
        );
      }
      return;
    }

    try {
      // Handle SingleProductLoaded state (from deep link)
      if (state is SingleProductLoaded) {
        final currentState = state as SingleProductLoaded;
        emit(currentState.copyWith(favoriteStatus: FormzStatus.inProgress));

        final updatedProduct = currentState.product.copyWith(
          isFavorite: !(currentState.product.isFavorite ?? false),
        );

        // Check if we have offline data or need to load from API
        if (featureFlagService.isOfflineCachingEnabled) {
          final localProducts = await localDbService.getAllProducts();

          if (localProducts.isEmpty) {
            // No offline data, fetch from API first
            final result = await repository.getAllProducts();

            if (result is RepoSuccess) {
              // Update the specific product with favorite status
              final allProducts = result.data.map((p) {
                return p.id == event.productId ? updatedProduct : p;
              }).toList();

              // Save to local DB
              await localDbService.saveProducts(allProducts);

              // Emit ProductsLoaded state with all products
              emit(
                ProductsLoaded(
                  products: allProducts,
                  filteredProducts: allProducts,
                ),
              );

              // Sync favorites and cart
              add(GetAllFavoriteProducts());
              add(GetCartProducts());
              return;
            } else if (result is RepoFailure) {
              emit(currentState.copyWith(favoriteStatus: FormzStatus.failure));
              return;
            }
          } else {
            // Offline data exists, update it
            final updatedList = localProducts.map((p) {
              return p.id == event.productId ? updatedProduct : p;
            }).toList();

            await localDbService.saveProducts(updatedList);

            // Emit ProductsLoaded state with all products
            emit(
              ProductsLoaded(
                products: updatedList,
                filteredProducts: updatedList,
              ),
            );

            // Sync favorites and cart
            add(GetAllFavoriteProducts());
            add(GetCartProducts());
            return;
          }
        } else {
          // Offline caching not enabled, just update single product state
          emit(
            currentState.copyWith(
              product: updatedProduct,
              favoriteStatus: FormzStatus.success,
            ),
          );
          return;
        }
      }

      // Handle ProductsLoaded state (existing code)
      if (state is ProductsLoaded) {
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
      }
    } catch (e) {
      if (state is ProductsLoaded) {
        emit(
          (state as ProductsLoaded).copyWith(
            favoriteStatus: FormzStatus.failure,
          ),
        );
      } else if (state is SingleProductLoaded) {
        emit(
          (state as SingleProductLoaded).copyWith(
            favoriteStatus: FormzStatus.failure,
          ),
        );
      }
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
      if (state is ProductsLoaded) {
        emit(
          (state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure),
        );
      } else if (state is SingleProductLoaded) {
        emit(
          (state as SingleProductLoaded).copyWith(
            cartStatus: FormzStatus.failure,
          ),
        );
      }
      return;
    }

    try {
      // Handle SingleProductLoaded state (from deep link)
      if (state is SingleProductLoaded) {
        final currentState = state as SingleProductLoaded;
        emit(currentState.copyWith(cartStatus: FormzStatus.inProgress));

        final updatedProduct = currentState.product.copyWith(
          isInCart: true,
          quantity: 1,
        );

        // Check if we have offline data or need to load from API
        if (featureFlagService.isOfflineCachingEnabled) {
          final localProducts = await localDbService.getAllProducts();

          if (localProducts.isEmpty) {
            // No offline data, fetch from API first
            final result = await repository.getAllProducts();

            if (result is RepoSuccess) {
              // Update the specific product with cart status
              final allProducts = result.data.map((p) {
                return p.id == event.productId ? updatedProduct : p;
              }).toList();

              // Save to local DB
              await localDbService.saveProducts(allProducts);

              // Emit ProductsLoaded state with all products
              emit(
                ProductsLoaded(
                  products: allProducts,
                  filteredProducts: allProducts,
                ),
              );

              // Sync favorites and cart
              add(GetAllFavoriteProducts());
              add(GetCartProducts());
              return;
            } else if (result is RepoFailure) {
              emit(currentState.copyWith(cartStatus: FormzStatus.failure));
              return;
            }
          } else {
            // Offline data exists, update it
            final updatedList = localProducts.map((p) {
              return p.id == event.productId ? updatedProduct : p;
            }).toList();

            await localDbService.saveProducts(updatedList);

            // Emit ProductsLoaded state with all products
            emit(
              ProductsLoaded(
                products: updatedList,
                filteredProducts: updatedList,
              ),
            );

            // Sync favorites and cart
            add(GetAllFavoriteProducts());
            add(GetCartProducts());
            return;
          }
        } else {
          // Offline caching not enabled, just update single product state
          emit(
            currentState.copyWith(
              product: updatedProduct,
              cartStatus: FormzStatus.success,
            ),
          );
          return;
        }
      }

      // Handle ProductsLoaded state (existing code)
      if (state is ProductsLoaded) {
        emit(
          (state as ProductsLoaded).copyWith(
            cartStatus: FormzStatus.inProgress,
          ),
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
      }
    } catch (e) {
      if (state is ProductsLoaded) {
        emit(
          (state as ProductsLoaded).copyWith(cartStatus: FormzStatus.failure),
        );
      } else if (state is SingleProductLoaded) {
        emit(
          (state as SingleProductLoaded).copyWith(
            cartStatus: FormzStatus.failure,
          ),
        );
      }
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

  Future<void> _onLoadSingleProduct(
    LoadSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    try {
      ProductResponse? product;

      // Check if products already loaded in memory
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;
        try {
          product = currentState.products.firstWhere(
            (p) => p.id == event.productId,
          );
          emit(SingleProductLoaded(product: product));
          return;
        } catch (_) {
          // Product not found in current state, continue to next check
        }
      }

      // Check local DB if offline caching enabled
      if (featureFlagService.isOfflineCachingEnabled) {
        final localProducts = await localDbService.getAllProducts();

        if (localProducts.isNotEmpty) {
          try {
            product = localProducts.firstWhere((p) => p.id == event.productId);
            emit(SingleProductLoaded(product: product));
            return;
          } catch (_) {
            // Product not found in local DB, continue to API call
          }
        }
      }

      // Fetch single product from API
      final result = await repository.getProductDetails(
        productId: event.productId,
      );

      if (result is RepoSuccess) {
        product = result.data;

        // If offline caching is enabled, merge with local data for cart/favorite status
        if (featureFlagService.isOfflineCachingEnabled) {
          final localProducts = await localDbService.getAllProducts();

          // Find if this product exists in local DB
          try {
            final existingProduct = localProducts.firstWhere(
              (p) => p.id == product!.id,
            );

            // Preserve cart and favorite status from local DB
            product = product?.copyWith(
              isFavorite: existingProduct.isFavorite,
              isInCart: existingProduct.isInCart,
              quantity: existingProduct.quantity,
            );
          } catch (_) {
            // Product doesn't exist in local DB, use API data as is
          }

          // Update or add product to local DB
          final updatedProducts = List<ProductResponse>.from(localProducts);
          final existingIndex = updatedProducts.indexWhere(
            (p) => p.id == product!.id,
          );

          if (existingIndex != -1) {
            updatedProducts[existingIndex] = product!;
          } else {
            updatedProducts.add(product!);
          }

          await localDbService.saveProducts(updatedProducts);
        }

        emit(SingleProductLoaded(product: product!));
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
          message: 'Failed to load product: ${e.toString()}',
          statusCode: null,
        ),
      );
    }
  }
}
