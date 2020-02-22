import 'dart:convert';

class ConversionItem {
  String from;
  String to;
  double value;

  ConversionItem({
    this.from,
    this.to,
    this.value,
  });

  factory ConversionItem.empty() {
    return ConversionItem(from: "", to: "", value: 0.0);
  }

  ConversionItem copyWith({
    String from,
    String to,
    double value,
  }) {
    return ConversionItem(
      from: from ?? this.from,
      to: to ?? this.to,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'value': value,
    };
  }

  static ConversionItem fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ConversionItem(
      from: map['from'],
      to: map['to'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  static ConversionItem fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'ConversionItem from: $from, to: $to, value: $value';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ConversionItem &&
      o.from == from &&
      o.to == to &&
      o.value == value;
  }

  @override
  int get hashCode => from.hashCode ^ to.hashCode ^ value.hashCode;
}
