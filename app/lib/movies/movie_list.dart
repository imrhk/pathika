import 'dart:convert';

import 'package:pathika/movies/movie_details.dart';

class MovieList {
  List<MovieDetails> items;
  MovieList({
    required this.items,
  });

  factory MovieList.empty() {
    return MovieList(items: []);
  }

  MovieList copyWith({
    List<MovieDetails>? items,
  }) {
    return MovieList(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toMap())),
    };
  }

  static MovieList? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return MovieList(
      items: List<MovieDetails>.from(
          map['items']?.map((x) => MovieDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static MovieList? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'MovieList items: $items';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieList && other.items == items;
  }

  @override
  int get hashCode => items.hashCode;
}
