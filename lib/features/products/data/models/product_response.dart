// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ProductResponse extends Equatable {
  final int? id;
  final String? title;
  final num? price;
  final String? description;
  final String? category;
  final String? image;
  final Rating? rating;
  final bool? isFavorite;
  final bool? isInCart;
  final int? quantity;
  const ProductResponse({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
    this.isFavorite,
    this.isInCart,
    this.quantity,
  });

  ProductResponse copyWith({
    int? id,
    String? title,
    num? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
    bool? isFavorite,
    bool? isInCart,
    int? quantity,
  }) {
    return ProductResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      isInCart: isInCart ?? this.isInCart,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating?.toMap(),
      'isFavorite': isFavorite,
      'isInCart': isInCart,
      'quantity': quantity,
    };
  }

  factory ProductResponse.fromMap(Map<String, dynamic> map) {
    return ProductResponse(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      price: map['price'] != null ? map['price'] as num : null,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      category: map['category'] != null ? map['category'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      rating: map['rating'] != null
          ? Rating.fromMap(map['rating'] as Map<String, dynamic>)
          : null,
      isFavorite: map['isFavorite'] != null ? map['isFavorite'] as bool : null,
      isInCart: map['isInCart'] != null ? map['isInCart'] as bool : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductResponse.fromJson(String source) =>
      ProductResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      price,
      description,
      category,
      image,
      rating,
      isFavorite,
      isInCart,
      quantity,
    ];
  }
}

class Rating extends Equatable {
  final num? rate;
  final num? count;
  const Rating({this.rate, this.count});

  Rating copyWith({num? rate, num? count}) {
    return Rating(rate: rate ?? this.rate, count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (rate != null) {
      result.addAll({'rate': rate});
    }
    if (count != null) {
      result.addAll({'count': count});
    }

    return result;
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(rate: map['rate'], count: map['count']);
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));

  @override
  String toString() => 'Rating(rate: $rate, count: $count)';

  @override
  List<Object?> get props => [rate, count];
}
