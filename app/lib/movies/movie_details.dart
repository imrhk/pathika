import 'dart:convert';

class MovieDetails {
  String title;
  String posterUrl;
  MovieDetails({
    this.title,
    this.posterUrl,
  });

  factory MovieDetails.empty() {
    return MovieDetails(posterUrl: '', title: '');
  }

  MovieDetails copyWith({
    String title,
    String posterUrl,
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

  static MovieDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MovieDetails(
      title: map['title'],
      posterUrl: map['poster_url'],
    );
  }

  String toJson() => json.encode(toMap());

  static MovieDetails fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'MovieDetails title: $title, poster_url: $posterUrl';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MovieDetails &&
      o.title == title &&
      o.posterUrl == posterUrl;
  }

  @override
  int get hashCode => title.hashCode ^ posterUrl.hashCode;
}
