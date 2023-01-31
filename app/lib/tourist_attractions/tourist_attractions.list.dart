import 'dart:convert';

import 'tourist_attraction_details.dart';

class TouristAttractionsList {
  List<TouristAttractionDetails> items;
  TouristAttractionsList({
    this.items = const [],
  });

  factory TouristAttractionsList.empty() {
    return TouristAttractionsList(items: []);
  }

  TouristAttractionsList copyWith({
    List<TouristAttractionDetails>? items,
  }) {
    return TouristAttractionsList(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toMap())),
    };
  }

  static TouristAttractionsList? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return TouristAttractionsList(
      items: List<TouristAttractionDetails>.from(
          map['items']?.map((x) => TouristAttractionDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static TouristAttractionsList? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'TouristAttractionsList items: $items';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TouristAttractionsList && other.items == items;
  }

  @override
  int get hashCode => items.hashCode;
}
