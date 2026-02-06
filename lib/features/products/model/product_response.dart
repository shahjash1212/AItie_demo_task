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
  const ProductResponse({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  ProductResponse copyWith({
    int? id,
    String? title,
    num? price,
    String? description,
    String? category,
    String? image,
    Rating? rating,
  }) {
    return ProductResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (title != null) {
      result.addAll({'title': title});
    }
    if (price != null) {
      result.addAll({'price': price});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (category != null) {
      result.addAll({'category': category});
    }
    if (image != null) {
      result.addAll({'image': image});
    }
    if (rating != null) {
      result.addAll({'rating': rating!.toMap()});
    }

    return result;
  }

  factory ProductResponse.fromMap(Map<String, dynamic> map) {
    return ProductResponse(
      id: map['id']?.toInt(),
      title: map['title'],
      price: map['price'],
      description: map['description'],
      category: map['category'],
      image: map['image'],
      rating: map['rating'] != null ? Rating.fromMap(map['rating']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductResponse.fromJson(String source) =>
      ProductResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductResponse(id: $id, title: $title, price: $price, description: $description, category: $category, image: $image, rating: $rating)';
  }

  @override
  List<Object?> get props {
    return [id, title, price, description, category, image, rating];
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
