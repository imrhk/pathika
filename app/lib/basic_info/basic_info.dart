import 'dart:convert';

class BasicInfo {
  final String name;
  final String id;
  final String? backgroundImage;
  final String? place;
  final String? licence;
  final String? photoBy;
  final String? attributionUrl;
  BasicInfo({
    required this.name,
    required this.id,
    this.backgroundImage,
    this.place,
    this.licence,
    this.photoBy,
    this.attributionUrl,
  });

  factory BasicInfo.empty() {
    return BasicInfo(
      id: "",
      name: "",
      attributionUrl: "",
      backgroundImage: "",
      licence: "",
      photoBy: "",
      place: "",
    );
  }

  BasicInfo copyWith({
    String? name,
    String? id,
    String? backgroundImage,
    String? place,
    String? licence,
    String? photoBy,
    String? attributionUrl,
  }) {
    return BasicInfo(
      name: name ?? this.name,
      id: id ?? this.id,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      place: place ?? this.place,
      licence: licence ?? this.licence,
      photoBy: photoBy ?? this.photoBy,
      attributionUrl: attributionUrl ?? this.attributionUrl,
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
    };
  }

  static BasicInfo? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return BasicInfo(
      name: map['name'],
      id: map['id'],
      backgroundImage: map['background_image'],
      place: map['place'],
      licence: map['licence'],
      photoBy: map['photo_by'],
      attributionUrl: map['attribution_url'],
    );
  }

  String toJson() => json.encode(toMap());

  static BasicInfo? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'BasicInfo name: $name, id: $id, background_image: $backgroundImage, place: $place, licence: $licence, photo_by: $photoBy, attribution_url: $attributionUrl';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BasicInfo &&
        other.name == name &&
        other.id == id &&
        other.backgroundImage == backgroundImage &&
        other.place == place &&
        other.licence == licence &&
        other.photoBy == photoBy &&
        other.attributionUrl == attributionUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        backgroundImage.hashCode ^
        place.hashCode ^
        licence.hashCode ^
        photoBy.hashCode ^
        attributionUrl.hashCode;
  }
}
