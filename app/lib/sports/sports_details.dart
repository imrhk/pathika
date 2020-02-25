import 'dart:convert';

class SportsDetails {
  final String title;
  final String footer;
  SportsDetails({
    this.title,
    this.footer,
  });

  factory SportsDetails.empty() {
    return SportsDetails(title: "", footer: "");
  }
  
  SportsDetails copyWith({
    String title,
    String footer,
  }) {
    return SportsDetails(
      title: title ?? this.title,
      footer: footer ?? this.footer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'footer': footer,
    };
  }

  static SportsDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SportsDetails(
      title: map['title'],
      footer: map['footer'],
    );
  }

  String toJson() => json.encode(toMap());

  static SportsDetails fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'SportsDetails title: $title, footer: $footer';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SportsDetails &&
      o.title == title &&
      o.footer == footer;
  }

  @override
  int get hashCode => title.hashCode ^ footer.hashCode;
}
