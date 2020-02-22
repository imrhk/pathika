import 'dart:convert';

class LanguageDetails {
  String primary;
  List<String> secondary;
  LanguageDetails({
    this.primary,
    this.secondary,
  });

  factory LanguageDetails.empty() {
    return LanguageDetails(primary: "", secondary: []);
  }

  LanguageDetails copyWith({
    String primary,
    List<String> secondary,
  }) {
    return LanguageDetails(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primary': primary,
      'secondary': List<dynamic>.from(secondary.map((x) => x)),
    };
  }

  static LanguageDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LanguageDetails(
      primary: map['primary'],
      secondary: List<String>.from(map['secondary']),
    );
  }

  String toJson() => json.encode(toMap());

  static LanguageDetails fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'LanguageDetails primary: $primary, secondary: $secondary';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LanguageDetails &&
        o.primary == primary &&
        o.secondary == secondary;
  }

  @override
  int get hashCode => primary.hashCode ^ secondary.hashCode;
}
