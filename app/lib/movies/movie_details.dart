import 'dart:convert';

class MovieDetails {
  String title;
  String? posterUrl;
  MovieDetails({
    required this.title,
    this.posterUrl,
  });

  factory MovieDetails.empty() {
    return MovieDetails(posterUrl: '', title: '');
  }

  MovieDetails copyWith({
    String? title,
    String? posterUrl,
  }) {
    return MovieDetails(
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'poster_url': posterUrl,
    };
  }

  static MovieDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return MovieDetails(
      title: map['title'],
      posterUrl: map['poster_url'],
    );
  }

  String toJson() => json.encode(toMap());

  static MovieDetails? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'MovieDetails title: $title, poster_url: $posterUrl';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieDetails &&
        other.title == title &&
        other.posterUrl == posterUrl;
  }

  @override
  int get hashCode => title.hashCode ^ posterUrl.hashCode;
}
