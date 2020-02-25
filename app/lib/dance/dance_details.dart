import 'dart:convert';

class DanceDetails {
  String title;
  DanceDetails({
    this.title,
  });

  factory DanceDetails.empty() {
    return DanceDetails(title: "");
  }

  DanceDetails copyWith({
    String title,
  }) {
    return DanceDetails(
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': title,
    };
  }

  static DanceDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return DanceDetails(
      title: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  static DanceDetails fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'DanceDetails title: $title';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is DanceDetails &&
      o.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}
