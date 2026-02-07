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
  final FormzStatus favoriteStatus;

  const ProductsLoaded({
    required this.products,
    this.favoriteStatus = FormzStatus.pure,
  });

  @override
  List<Object?> get props => [products, favoriteStatus];

  ProductsLoaded copyWith({
    List<ProductResponse>? products,
    FormzStatus? favoriteStatus,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      favoriteStatus: favoriteStatus ?? FormzStatus.initial,
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
