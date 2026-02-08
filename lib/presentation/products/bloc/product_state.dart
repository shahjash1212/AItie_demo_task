part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductsLoaded extends ProductState {
  final List<ProductResponse> products;
  final List<ProductResponse> favoriteProducts;
  final List<ProductResponse> cartProducts;

  final FormzStatus favoriteStatus;
  final FormzStatus cartStatus;
  final FormzStatus favoriteProductStatus;
  final FormzStatus clearFilterState;

  final String? searchQuery;
  final String selectedCategory;
  final List<ProductResponse> filteredProducts;

  const ProductsLoaded({
    required this.products,
    this.favoriteProducts = const [],
    this.cartProducts = const [],
    this.filteredProducts = const [],
    this.cartStatus = FormzStatus.pure,
    this.favoriteStatus = FormzStatus.pure,
    this.clearFilterState = FormzStatus.pure,
    this.favoriteProductStatus = FormzStatus.pure,

    this.searchQuery,
    this.selectedCategory = 'All',
  });

  @override
  List<Object?> get props => [
    products,
    favoriteStatus,
    cartProducts,
    clearFilterState,
    favoriteProductStatus,
    favoriteProducts,
    cartStatus,
    filteredProducts,
    searchQuery,
    selectedCategory,
  ];

  ProductsLoaded copyWith({
    List<ProductResponse>? products,
    List<ProductResponse>? favoriteProducts,
    List<ProductResponse>? filteredProducts,
    List<ProductResponse>? cartProducts,
    FormzStatus? favoriteStatus,
    FormzStatus? clearFilterState,
    FormzStatus? cartStatus,
    FormzStatus? favoriteProductStatus,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      cartProducts: cartProducts ?? this.cartProducts,
      favoriteStatus: favoriteStatus ?? FormzStatus.initial,
      cartStatus: cartStatus ?? FormzStatus.initial,
      clearFilterState: clearFilterState ?? FormzStatus.initial,
      favoriteProductStatus: favoriteProductStatus ?? FormzStatus.initial,
      searchQuery: searchQuery ?? '',
      selectedCategory: selectedCategory ?? 'All',
    );
  }
}

class ProductError extends ProductState {
  final String message;
  final int? statusCode;

  const ProductError({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class SingleProductLoaded extends ProductState {
  final ProductResponse product;
  final FormzStatus favoriteStatus;
  final FormzStatus cartStatus;

  const SingleProductLoaded({
    required this.product,
    this.favoriteStatus = FormzStatus.initial,
    this.cartStatus = FormzStatus.initial,
  });

  SingleProductLoaded copyWith({
    ProductResponse? product,
    FormzStatus? favoriteStatus,
    FormzStatus? cartStatus,
  }) {
    return SingleProductLoaded(
      product: product ?? this.product,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
      cartStatus: cartStatus ?? this.cartStatus,
    );
  }

  @override
  List<Object?> get props => [product, favoriteStatus, cartStatus];
}
