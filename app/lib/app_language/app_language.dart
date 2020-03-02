import 'dart:convert';

class AppLanguage {
  final String id;
  final String name;
  final String msg;
  final List<int> color;
  AppLanguage({
    this.id,
    this.name,
    this.msg,
    this.color = const [0,0,0,0],
  });

  AppLanguage copyWith({
    String id,
    String name,
    String msg,
    List<int> color,
  }) {
    return AppLanguage(
      id: id ?? this.id,
      name: name ?? this.name,
      msg: msg ?? this.msg,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'msg': msg,
      'color': List<dynamic>.from(color.map((x) => x)),
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
      color: map['color'] != null ? List<int>.from(map['color']) : [0,0,0,0],
    );
  }

  String toJson() => json.encode(toMap());

  static AppLanguage fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppLanguage(id: $id, name: $name, msg: $msg, color: $color)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is AppLanguage &&
      o.id == id &&
      o.name == name &&
      o.msg == msg &&
      o.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      msg.hashCode ^
      color.hashCode;
  }
}
