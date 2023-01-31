import 'dart:convert';

class FoodItemDetails {
  final String label;
  final String? photo;
  final bool isVeg;
  final bool isNonVeg;
  final String? photoBy;
  final String? licence;
  final String? attributionUrl;
  FoodItemDetails({
    required this.label,
    this.photo,
    this.isVeg = false,
    this.isNonVeg = false,
    this.photoBy,
    this.licence,
    this.attributionUrl,
  });

  factory FoodItemDetails.empty() {
    return FoodItemDetails(
        label: "",
        isVeg: false,
        isNonVeg: false,
        licence: "",
        photo: "",
        photoBy: "",
        attributionUrl: "");
  }

  FoodItemDetails copyWith({
    String? label,
    String? photo,
    bool? isVeg,
    bool? isNonVeg,
    String? photoBy,
    String? licence,
    String? attributionurl,
  }) {
    return FoodItemDetails(
      label: label ?? this.label,
      photo: photo ?? this.photo,
      isVeg: isVeg ?? this.isVeg,
      isNonVeg: isNonVeg ?? this.isNonVeg,
      photoBy: photoBy ?? this.photoBy,
      licence: licence ?? this.licence,
      attributionUrl: attributionurl ?? attributionUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'photo': photo,
      'is_veg': isVeg,
      'is_non_veg': isNonVeg,
      'photo_by': photoBy,
      'licence': licence,
      'attribution_url': attributionUrl,
    };
  }

  static FoodItemDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return FoodItemDetails(
      label: map['label'],
      photo: map['photo'],
      isVeg: map['is_veg'],
      isNonVeg: map['is_non_veg'],
      photoBy: map['photo_by'],
      licence: map['licence'],
      attributionUrl: map['attribution_url'],
    );
  }

  String toJson() => json.encode(toMap());

  static FoodItemDetails? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodItemDetails label: $label, photo: $photo, is_veg: $isVeg, is_non_veg: $isNonVeg, photo_by: $photoBy, licence: $licence, attribution_url: $attributionUrl';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodItemDetails &&
        other.label == label &&
        other.photo == photo &&
        other.isVeg == isVeg &&
        other.isNonVeg == isNonVeg &&
        other.photoBy == photoBy &&
        other.licence == licence &&
        other.attributionUrl == attributionUrl;
  }

  @override
  int get hashCode {
    return label.hashCode ^
        photo.hashCode ^
        isVeg.hashCode ^
        isNonVeg.hashCode ^
        photoBy.hashCode ^
        licence.hashCode ^
        attributionUrl.hashCode;
  }
}
