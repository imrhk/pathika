import 'dart:convert';

class ConversionItem {
  final String from;
  final String to;
  final double value;
  final int quantity;
  ConversionItem({
    required this.from,
    required this.to,
    required this.value,
    required this.quantity,
  });

  factory ConversionItem.empty() {
    return ConversionItem(from: "", to: "", quantity: 0, value: 0);
  }

  ConversionItem copyWith({
    String? from,
    String? to,
    double? value,
    int? quantity,
  }) {
    return ConversionItem(
      from: from ?? this.from,
      to: to ?? this.to,
      value: value ?? this.value,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'value': value,
      'quantity': quantity,
    };
  }

  static ConversionItem? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return ConversionItem(
      from: map['from'],
      to: map['to'],
      value: map['value'],
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  static ConversionItem? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversionItem from: $from, to: $to, value: $value, quantity: $quantity';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversionItem &&
        other.from == from &&
        other.to == to &&
        other.value == value &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return from.hashCode ^ to.hashCode ^ value.hashCode ^ quantity.hashCode;
  }
}
