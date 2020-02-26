import 'dart:convert';

import 'conversion_item.dart';

class ConversionDetails {
  List<ConversionItem> items;
  ConversionDetails({
    this.items,
  });

  factory ConversionDetails.empty() {
    return ConversionDetails(items: [ConversionItem.empty()]);
  }

  ConversionDetails copyWith({
    List<ConversionItem> items,
  }) {
    return ConversionDetails(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toMap())),
    };
  }

  static ConversionDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ConversionDetails(
      items: List<ConversionItem>.from(map['items']?.map((x) => ConversionItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static ConversionDetails fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'ConversionDetails items: $items';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ConversionDetails &&
      o.items == items;
  }

  @override
  int get hashCode => items.hashCode;
}

