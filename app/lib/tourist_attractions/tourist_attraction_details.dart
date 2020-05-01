import 'dart:convert';

class TouristAttractionDetails {
  final String name;
  final String placeId;
  final String description;
  final String photos;
  final List<String> htmlAttributions;
  final String licence;
  TouristAttractionDetails({
    this.name,
    this.placeId,
    this.description,
    this.photos,
    this.htmlAttributions,
    this.licence
  });

  factory TouristAttractionDetails.empty() {
    return TouristAttractionDetails(
        description: "",
        htmlAttributions: [],
        name: "",
        photos: "",
        placeId: "",
        licence: "");
  }

  TouristAttractionDetails copyWith({
    String name,
    String placeId,
    String description,
    String photos,
    List<String> htmlAttributions,
    String licence,
  }) {
    return TouristAttractionDetails(
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      htmlAttributions: htmlAttributions ?? this.htmlAttributions,
      licence: licence ?? this.licence,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'place_id': placeId,
      'description': description,
      'photos': photos,
      'html_attributions': List<dynamic>.from(htmlAttributions.map((x) => x)),
      'licence': licence,
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
      licence: map['licence'],
    );
  }

  String toJson() => json.encode(toMap());

  static TouristAttractionDetails fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'TouristAttractionDetails name: $name, place_id: $placeId, description: $description, photos: $photos, html_attributions: $htmlAttributions, licence: $licence';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TouristAttractionDetails &&
        o.name == name &&
        o.placeId == placeId &&
        o.description == description &&
        o.photos == photos &&
        o.htmlAttributions == htmlAttributions &&
        o.licence == licence;
  }

  @override
  int get hashCode {
    final hashCode =  name.hashCode ^
        placeId.hashCode ^
        description.hashCode ^
        photos.hashCode ^
        htmlAttributions.hashCode;
    if(licence != null) {
      return hashCode ^ licence.hashCode;
    }
    return hashCode;
  }
}
