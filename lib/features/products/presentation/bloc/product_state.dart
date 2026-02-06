import 'package:aitie_demo/features/products/data/models/product_response.dart';
import 'package:equatable/equatable.dart';

/// Product BLoC States
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProductInitial extends ProductState {
  const ProductInitial();
}

/// Loading state
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Products loaded successfully
class ProductsLoaded extends ProductState {
  final List<ProductResponse> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

/// Product details loaded successfully
class ProductDetailsLoaded extends ProductState {
  final ProductResponse product;

  const ProductDetailsLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

/// Error state
class ProductError extends ProductState {
  final String message;
  final int? statusCode;

  const ProductError({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}
