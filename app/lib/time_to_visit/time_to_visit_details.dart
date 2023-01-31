import 'dart:convert';

class TimeToVisitDetails {
  String primary;
  String secondary;
  TimeToVisitDetails({
    required this.primary,
    required this.secondary,
  });

  factory TimeToVisitDetails.empty() {
    return TimeToVisitDetails(primary: "", secondary: "");
  }

  TimeToVisitDetails copyWith({
    String? primary,
    String? secondary,
  }) {
    return TimeToVisitDetails(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primary': primary,
      'secondary': secondary,
    };
  }

  static TimeToVisitDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return TimeToVisitDetails(
      primary: map['primary'],
      secondary: map['secondary'],
    );
  }

  String toJson() => json.encode(toMap());

  static TimeToVisitDetails? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'TimeToVisitDetails primary: $primary, secondary: $secondary';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeToVisitDetails &&
        other.primary == primary &&
        other.secondary == secondary;
  }

  @override
  int get hashCode => primary.hashCode ^ secondary.hashCode;
}
