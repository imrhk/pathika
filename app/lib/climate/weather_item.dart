import 'dart:convert';

class WeatherItem {
  final String emoji;
  final String name;
  final String temp;
  final String duration;
  const WeatherItem({
    required this.emoji,
    required this.name,
    required this.temp,
    required this.duration,
  });

  WeatherItem copyWith({
    String? emoji,
    String? name,
    String? temp,
    String? duration,
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

  static WeatherItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return WeatherItem(
      emoji: map['emoji'],
      name: map['name'],
      temp: map['temp'],
      duration: map['duration'],
    );
  }

  String toJson() => json.encode(toMap());

  static WeatherItem? fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'WeatherItem emoji: $emoji, name: $name, temp: $temp, duration: $duration';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeatherItem &&
        other.emoji == emoji &&
        other.name == name &&
        other.temp == temp &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return emoji.hashCode ^ name.hashCode ^ temp.hashCode ^ duration.hashCode;
  }
}
