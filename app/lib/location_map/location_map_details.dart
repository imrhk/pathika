import 'dart:convert';

class LocationMapDetails {
  List<String> items;
  LocationMapDetails({
    this.items = const [],
  });

  factory LocationMapDetails.empty() {
    return LocationMapDetails(items: []);
  }

  LocationMapDetails copyWith({
    List<String>? items,
  }) {
    return LocationMapDetails(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': List<dynamic>.from(items.map((x) => x)),
    };
  }

  static LocationMapDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return LocationMapDetails(
      items: List<String>.from(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  static LocationMapDetails? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'LocationMapDetails items: $items';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationMapDetails && other.items == items;
  }

  @override
  int get hashCode => items.hashCode;
}
