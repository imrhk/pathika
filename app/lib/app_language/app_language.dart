import 'dart:convert';

class AppLanguage {
  final String id;
  final String name;
  final String msg;
  AppLanguage({
    this.id,
    this.name,
    this.msg,
  });

  AppLanguage copyWith({
    String id,
    String name,
    String msg,
  }) {
    return AppLanguage(
      id: id ?? this.id,
      name: name ?? this.name,
      msg: msg ?? this.msg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'msg': msg,
    };
  }

  static List<AppLanguage> fromList(List<dynamic> list) {
    return list.map((item) => fromMap(item)).toList();
  }

  static AppLanguage fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AppLanguage(
      id: map['id'],
      name: map['name'],
      msg: map['msg'],
    );
  }

  String toJson() => json.encode(toMap());

  static AppLanguage fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'AppLanguage id: $id, name: $name, msg: $msg';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is AppLanguage &&
      o.id == id &&
      o.name == name &&
      o.msg == msg;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ msg.hashCode;
}
