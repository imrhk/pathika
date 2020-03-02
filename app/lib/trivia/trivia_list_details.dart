import 'dart:convert';

class TriviaListDetails {
  final List<String> items;
  TriviaListDetails({
    this.items,
  });

  factory TriviaListDetails.empty() {
    return TriviaListDetails(items: []);
  }

  TriviaListDetails copyWith({
    List<String> items,
  }) {
    return TriviaListDetails(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': List<dynamic>.from(items.map((x) => x)),
    };
  }

  static TriviaListDetails fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TriviaListDetails(
      items: List<String>.from(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  static TriviaListDetails fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'TriviaListDetails(items: $items)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TriviaListDetails &&
      o.items == items;
  }

  @override
  int get hashCode => items.hashCode;
}