import 'dart:convert';

class CountryDetails {
  String name;
  String continent;
  CountryDetails({
    this.name,
    this.continent,
  });

  factory CountryDetails.empty() {
    return CountryDetails(name: "", continent: "");
  }

  CountryDetails copyWith({
    String name,
    String continent,
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

  static CountryDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CountryDetails(
      name: map['name'],
      continent: map['continent'],
    );
  }

  String toJson() => json.encode(toMap());

  static CountryDetails fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'CountryDetails name: $name, continent: $continent';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CountryDetails &&
      o.name == name &&
      o.continent == continent;
  }

  @override
  int get hashCode => name.hashCode ^ continent.hashCode;
}
