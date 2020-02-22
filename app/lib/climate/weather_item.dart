import 'dart:convert';

class WeatherItem {
  String emoji;
  String name;
  String temp;
  String duration;
  WeatherItem({
    this.emoji,
    this.name,
    this.temp,
    this.duration,
  });
  
  WeatherItem copyWith({
    String emoji,
    String name,
    String temp,
    String duration,
  }) {
    return WeatherItem(
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
      temp: temp ?? this.temp,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'name': name,
      'temp': temp,
      'duration': duration,
    };
  }

  static WeatherItem fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return WeatherItem(
      emoji: map['emoji'],
      name: map['name'],
      temp: map['temp'],
      duration: map['duration'],
    );
  }

  String toJson() => json.encode(toMap());

  static WeatherItem fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'WeatherItem emoji: $emoji, name: $name, temp: $temp, duration: $duration';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is WeatherItem &&
      o.emoji == emoji &&
      o.name == name &&
      o.temp == temp &&
      o.duration == duration;
  }

  @override
  int get hashCode {
    return emoji.hashCode ^
      name.hashCode ^
      temp.hashCode ^
      duration.hashCode;
  }

}
