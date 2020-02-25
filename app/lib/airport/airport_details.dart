import 'dart:convert';

class AirportDetails {
  String name;
  AirportDetails({
    this.name,
  });

  factory AirportDetails.empty() {
    return AirportDetails(name: "");
  }

  AirportDetails copyWith({
    String name,
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

  static AirportDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AirportDetails(
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  static AirportDetails fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'AirportDetails name: $name';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is AirportDetails &&
      o.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
