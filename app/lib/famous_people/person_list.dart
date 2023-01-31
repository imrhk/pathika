import 'dart:convert';

import 'person_details.dart';

class PersonList {
  List<PersonDetails> items;
  PersonList({
    this.items = const [],
  });

  factory PersonList.empty() {
    return PersonList(items: []);
  }

  PersonList copyWith({
    List<PersonDetails>? items,
  }) {
    return PersonList(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': List<dynamic>.from(items.map((x) => x.toMap())),
    };
  }

  static PersonList? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return PersonList(
      items: List<PersonDetails>.from(
          map['items']?.map((x) => PersonDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static PersonList? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'FamousPeopleList items: $items';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonList && other.items == items;
  }

  @override
  int get hashCode => items.hashCode;
}
