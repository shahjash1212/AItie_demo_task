import 'package:equatable/equatable.dart';

/// Product BLoC Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all products
class LoadProductsEvent extends ProductEvent {
  const LoadProductsEvent();
}

/// Event to load product details by ID
class LoadProductDetailsEvent extends ProductEvent {
  final int productId;

  const LoadProductDetailsEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event to refresh products
class RefreshProductsEvent extends ProductEvent {
  const RefreshProductsEvent();
}
