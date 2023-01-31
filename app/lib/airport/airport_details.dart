import 'dart:convert';

class AirportDetails {
  final String name;
  AirportDetails({
    required this.name,
  });

  factory AirportDetails.empty() {
    return AirportDetails(name: "");
  }

  AirportDetails copyWith({
    String? name,
  }) {
    return AirportDetails(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  static AirportDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return AirportDetails(
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  static AirportDetails? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'AirportDetails name: $name';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AirportDetails && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
