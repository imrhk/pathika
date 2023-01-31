import 'dart:convert';

class PersonDetails {
  final String name;
  final String? avatarUrl;
  final String? work;
  final String? place;
  final String? licence;
  final String? photoBy;
  final String? attributionUrl;
  PersonDetails({
    required this.name,
    this.avatarUrl,
    this.work,
    this.place,
    this.licence,
    this.photoBy,
    this.attributionUrl,
  });

  factory PersonDetails.empty() {
    return PersonDetails(
        attributionUrl: "",
        avatarUrl: "",
        licence: "",
        name: "",
        photoBy: "",
        place: "",
        work: "");
  }

  PersonDetails copyWith({
    String? name,
    String? avatarUrl,
    String? work,
    String? place,
    String? licence,
    String? photoBy,
    String? attributionUrl,
  }) {
    return PersonDetails(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      work: work ?? this.work,
      place: place ?? this.place,
      licence: licence ?? this.licence,
      photoBy: photoBy ?? this.photoBy,
      attributionUrl: attributionUrl ?? this.attributionUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatar_url': avatarUrl,
      'work': work,
      'place': place,
      'licence': licence,
      'photo_by': photoBy,
      'attribution_url': attributionUrl,
    };
  }

  static PersonDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return PersonDetails(
      name: map['name'],
      avatarUrl: map['avatar_url'],
      work: map['work'],
      place: map['place'],
      licence: map['licence'],
      photoBy: map['photo_by'],
      attributionUrl: map['attribution_url'],
    );
  }

  String toJson() => json.encode(toMap());

  static PersonDetails? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'PersionDetails name: $name, avatar_url: $avatarUrl, work: $work, place: $place, licence: $licence, photo_by: $photoBy, attribution_url: $attributionUrl';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonDetails &&
        other.name == name &&
        other.avatarUrl == avatarUrl &&
        other.work == work &&
        other.place == place &&
        other.licence == licence &&
        other.photoBy == photoBy &&
        other.attributionUrl == attributionUrl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        avatarUrl.hashCode ^
        work.hashCode ^
        place.hashCode ^
        licence.hashCode ^
        photoBy.hashCode ^
        attributionUrl.hashCode;
  }
}
