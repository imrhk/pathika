import 'dart:convert';

class LanguageDetails {
  final String primary;
  final List<String> secondary;
  LanguageDetails({
    required this.primary,
    this.secondary = const [],
  });

  factory LanguageDetails.empty() {
    return LanguageDetails(primary: "", secondary: []);
  }

  LanguageDetails copyWith({
    String? primary,
    List<String>? secondary,
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

  static LanguageDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return LanguageDetails(
      primary: map['primary'],
      secondary: List<String>.from(map['secondary']),
    );
  }

  String toJson() => json.encode(toMap());

  static LanguageDetails? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'LanguageDetails primary: $primary, secondary: $secondary';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LanguageDetails &&
        other.primary == primary &&
        other.secondary == secondary;
  }

  @override
  int get hashCode => primary.hashCode ^ secondary.hashCode;
}
