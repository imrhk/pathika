import 'dart:convert';

class IndustryDetails {
  String primary;
  List<String> secondary;
  IndustryDetails({
    this.primary,
    this.secondary,
  });

  factory IndustryDetails.empty() {
    return IndustryDetails(primary: "", secondary: []);
  }

  IndustryDetails copyWith({
    String primary,
    List<String> secondary,
  }) {
    return IndustryDetails(
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

  static IndustryDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return IndustryDetails(
      primary: map['primary'],
      secondary: List<String>.from(map['secondary']),
    );
  }

  String toJson() => json.encode(toMap());

  static IndustryDetails fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'LanguageDetails primary: $primary, secondary: $secondary';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is IndustryDetails &&
        o.primary == primary &&
        o.secondary == secondary;
  }

  @override
  int get hashCode => primary.hashCode ^ secondary.hashCode;
}
