import 'dart:convert';

class PlaceInfo {
  final String id;
  final String name;
  PlaceInfo({
    this.id,
    this.name,
  });

  PlaceInfo copyWith({
    String id,
    String name,
  }) {
    return PlaceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static PlaceInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return PlaceInfo(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  static PlaceInfo fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'PlaceInfo(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is PlaceInfo &&
      o.id == id &&
      o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
