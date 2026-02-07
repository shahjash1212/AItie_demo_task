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

class AddToCart extends ProductEvent {
  final int productId;

  const AddToCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class GetCartProducts extends ProductEvent {
  final String? searchQuery;
  final String? selectedCategory;
  const GetCartProducts({this.searchQuery, this.selectedCategory});

  @override
  List<Object?> get props => [searchQuery, selectedCategory];
}

class GetAllFavoriteProducts extends ProductEvent {
  final String? searchQuery;
  final String? selectedCategory;
  const GetAllFavoriteProducts({this.searchQuery, this.selectedCategory});

  @override
  List<Object?> get props => [searchQuery, selectedCategory];
}

class RemoveFromCart extends ProductEvent {
  final int productId;
  const RemoveFromCart({required this.productId});
  @override
  List<Object?> get props => [productId];
}

class UpdateCartQuantity extends ProductEvent {
  final int productId;
  final int quantity;
  const UpdateCartQuantity({required this.productId, required this.quantity});
  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCart extends ProductEvent {
  const ClearCart();
}

class ClearDatabaseEvent extends ProductEvent {}

class RefreshProductsEvent extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;
  const SearchProducts({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends ProductEvent {
  final String? category;
  const FilterByCategory({this.category});

  @override
  List<Object?> get props => [category];
}

class ClearFilters extends ProductEvent {
  final bool isSearchQueryCleared;
  final bool isCategoryCleared;
  const ClearFilters({
    this.isSearchQueryCleared = false,
    this.isCategoryCleared = false,
  });

  @override
  List<Object?> get props => [isSearchQueryCleared, isCategoryCleared];
}
