// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state
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

  final String? searchQuery;
  final String? selectedCategory;
  final List<ProductResponse> filteredProducts;

  const ProductsLoaded({
    required this.products,
    this.favoriteProducts = const [],
    this.cartProducts = const [],
    this.filteredProducts = const [],
    this.favoriteStatus = FormzStatus.pure,
    this.cartStatus = FormzStatus.pure,
    this.favoriteProductStatus = FormzStatus.pure,

    this.searchQuery,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [
    products,
    favoriteStatus,
    cartProducts,
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
      favoriteProductStatus: favoriteProductStatus ?? FormzStatus.initial,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
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
