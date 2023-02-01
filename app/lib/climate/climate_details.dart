import 'dart:convert';

import 'weather_item.dart';

class ClimateDetails {
  String type;
  List<WeatherItem> items;
  ClimateDetails({
    required this.type,
    required this.items,
  });

  factory ClimateDetails.empty() {
    return ClimateDetails(type: "", items: []);
  }

  ClimateDetails copyWith({
    String? type,
    List<WeatherItem>? items,
  }) {
    return ClimateDetails(
      type: type ?? this.type,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'items': List<dynamic>.from(items.map((x) => x.toMap())),
    };
  }

  static ClimateDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return ClimateDetails(
      type: map['type'],
      items: List<WeatherItem>.from(
          map['items']?.map((x) => WeatherItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static ClimateDetails? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'ClimateDetails type: $type, items: $items';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClimateDetails &&
        other.type == type &&
        other.items == items;
  }

  @override
  int get hashCode => type.hashCode ^ items.hashCode;
}
