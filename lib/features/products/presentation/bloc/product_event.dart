part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  const LoadProductsEvent();
}

class AddToFavorite extends ProductEvent {
  final int productId;

  const AddToFavorite({required this.productId});

  @override
  List<Object?> get props => [productId];
}
