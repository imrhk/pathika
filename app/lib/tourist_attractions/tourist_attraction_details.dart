import 'dart:convert';

class TouristAttractionDetails {
  final String name;
  final String placeId;
  final String description;
  final String photos;
  final List<String> htmlAttributions;
  TouristAttractionDetails({
    this.name,
    this.placeId,
    this.description,
    this.photos,
    this.htmlAttributions,
  });

  factory TouristAttractionDetails.empty() {
    return TouristAttractionDetails(
        description: "",
        htmlAttributions: [],
        name: "",
        photos: "",
        placeId: "");
  }

  TouristAttractionDetails copyWith({
    String name,
    String placeId,
    String description,
    String photos,
    List<String> htmlAttributions,
  }) {
    return TouristAttractionDetails(
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'place_id': placeId,
      'description': description,
      'photos': photos,
      'html_attributions': List<dynamic>.from(htmlAttributions.map((x) => x)),
    };
  }

  static TouristAttractionDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TouristAttractionDetails(
      name: map['name'],
      placeId: map['place_id'],
      description: map['description'],
      photos: map['photos'],
      htmlAttributions: List<String>.from(map['html_attributions']),
    );
  }

  String toJson() => json.encode(toMap());

  static TouristAttractionDetails fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'TouristAttractionDetails name: $name, place_id: $placeId, description: $description, photos: $photos, html_attributions: $htmlAttributions';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TouristAttractionDetails &&
        o.name == name &&
        o.placeId == placeId &&
        o.description == description &&
        o.photos == photos &&
        o.htmlAttributions == htmlAttributions;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        placeId.hashCode ^
        description.hashCode ^
        photos.hashCode ^
        htmlAttributions.hashCode;
  }
}
