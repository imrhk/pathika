import 'dart:convert';

class PlaceInfo {
  final String name;
  final String id;
  final String backgroundImage;
  final String place;
  final String licence;
  final String photoBy;
  final String attributionUrl;
  final String country;
  PlaceInfo({
    this.name,
    this.id,
    this.backgroundImage,
    this.place,
    this.licence,
    this.photoBy,
    this.attributionUrl,
    this.country,
  });

  factory PlaceInfo.empty() {
    return PlaceInfo(
      id: "",
      name: "",
      attributionUrl: "",
      backgroundImage: "",
      licence: "",
      photoBy: "",
      place: "",
      country: "",
    );
  }

  PlaceInfo copyWith({
    String name,
    String id,
    String backgroundImage,
    String place,
    String licence,
    String photoBy,
    String attributionUrl,
    String country,
  }) {
    return PlaceInfo(
      name: name ?? this.name,
      id: id ?? this.id,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      place: place ?? this.place,
      licence: licence ?? this.licence,
      photoBy: photoBy ?? this.photoBy,
      attributionUrl: attributionUrl ?? this.attributionUrl,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'background_image': backgroundImage,
      'place': place,
      'licence': licence,
      'photo_by': photoBy,
      'attribution_url': attributionUrl,
      'country' : country,
    };
  }

  static PlaceInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PlaceInfo(
      name: map['name'],
      id: map['id'],
      backgroundImage: map['background_image'],
      place: map['place'],
      licence: map['licence'],
      photoBy: map['photo_by'],
      attributionUrl: map['attribution_url'],
      country: map['country'],
    );
  }

  String toJson() => json.encode(toMap());

  static PlaceInfo fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaceInfo name: $name, id: $id, background_image: $backgroundImage, place: $place, licence: $licence, photo_by: $photoBy, attribution_url: $attributionUrl, country: $country';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PlaceInfo &&
        o.name == name &&
        o.id == id &&
        o.backgroundImage == backgroundImage &&
        o.place == place &&
        o.licence == licence &&
        o.photoBy == photoBy &&
        o.attributionUrl == attributionUrl &&
        o.country == country;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        backgroundImage.hashCode ^
        place.hashCode ^
        licence.hashCode ^
        photoBy.hashCode ^
        attributionUrl.hashCode ^
        country.hashCode;
  }
}
