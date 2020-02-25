import 'dart:convert';

import 'package:pathika/food/food_item_details.dart';

class FoodItemsList {
  List<FoodItemDetails> items;
  FoodItemsList({
    this.items,
  });

  factory FoodItemsList.empty() {
    return FoodItemsList(items: []);
  }

  FoodItemsList copyWith({
    List<FoodItemDetails> items,
  }) {
    return FoodItemsList(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toMap())),
    };
  }

  static FoodItemsList fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FoodItemsList(
      items: List<FoodItemDetails>.from(
          map['items']?.map((x) => FoodItemDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static FoodItemsList fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'FoodItemsList items: $items';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FoodItemsList && o.items == items;
  }

  @override
  int get hashCode => items.hashCode;
}