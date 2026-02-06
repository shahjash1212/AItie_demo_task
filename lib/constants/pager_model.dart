// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:aitie_demo/constants/trends_filter_enum.dart';
import 'package:equatable/equatable.dart';

class PagerRequest extends Equatable {
  final int page;
  final int perPage;
  final String? search;
  final List<int> categoryIds;
  final TrendFilterEnum? filter;
  final String? period;
  const PagerRequest({
    this.page = 1,
    this.perPage = 10,
    this.search,
    this.categoryIds = const [],
    this.filter,
    this.period,
  });

  PagerRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    TrendFilterEnum? filter,
    List<int>? categoryIds,
    String? period,
  }) {
    return PagerRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      filter: filter ?? this.filter,
      categoryIds: categoryIds ?? this.categoryIds,
      period: period ?? this.period,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['page'] = page;

    map['perPage'] = perPage;

    if (search != null) {
      map['search'] = search;
    }

    if (categoryIds.isNotEmpty) {
      map['categoryIds'] = categoryIds;
    }
    if (filter != null) {
      map['filter'] = filter?.toStringValue();
    }
    if (period != null) {
      map['period'] = period;
    }

    return map;
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    page,
    perPage,
    search,
    categoryIds,
    filter,
    period,
  ];
}

class PagerModel extends Equatable {
  final int? currentPage;
  final int? lastPage;
  final int? total;
  final int? from;
  final int? to;
  final int? perPage;
  const PagerModel({
    this.currentPage,
    this.lastPage,
    this.total,
    this.from,
    this.to,
    this.perPage,
  });

  PagerModel copyWith({
    int? currentPage,
    int? lastPage,
    int? total,
    int? from,
    int? to,
    int? perPage,
  }) {
    return PagerModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      from: from ?? this.from,
      to: to ?? this.to,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'current_page': currentPage,
      'last_page': lastPage,
      'total': total,
      'from': from,
      'to': to,
      'per_page': perPage,
    };
  }

  factory PagerModel.fromMap(Map<String, dynamic> map) {
    return PagerModel(
      currentPage: map['current_page'] != null
          ? map['current_page'] as int
          : null,
      lastPage: map['last_page'] != null ? map['last_page'] as int : null,
      total: map['total'] != null ? map['total'] as int : null,
      from: map['from'] != null ? map['from'] as int : null,
      to: map['to'] != null ? map['to'] as int : null,
      perPage: map['per_page'] != null ? map['per_page'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PagerModel.fromJson(String source) =>
      PagerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [currentPage, lastPage, total, from, to, perPage];
  }
}
