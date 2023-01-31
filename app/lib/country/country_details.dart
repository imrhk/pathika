import 'dart:convert';

class CountryDetails {
  final String name;
  final String continent;
  CountryDetails({
    required this.name,
    required this.continent,
  });

  factory CountryDetails.empty() {
    return CountryDetails(name: "", continent: "");
  }

  CountryDetails copyWith({
    String? name,
    String? continent,
  }) {
    return CountryDetails(
      name: name ?? this.name,
      continent: continent ?? this.continent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'continent': continent,
    };
  }

  static CountryDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return CountryDetails(
      name: map['name'],
      continent: map['continent'],
    );
  }

  String toJson() => json.encode(toMap());

  static CountryDetails? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() => 'CountryDetails name: $name, continent: $continent';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryDetails &&
        other.name == name &&
        other.continent == continent;
  }

  @override
  int get hashCode => name.hashCode ^ continent.hashCode;
}
