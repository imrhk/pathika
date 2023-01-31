import 'dart:convert';

class CurrencyDetails {
  final String symbol;
  final String name;
  final String code;
  CurrencyDetails({
    required this.symbol,
    required this.name,
    required this.code,
  });

  factory CurrencyDetails.empty() {
    return CurrencyDetails(name: "", symbol: "", code: "");
  }

  CurrencyDetails copyWith({
    String? symbol,
    String? name,
    String? code,
  }) {
    return CurrencyDetails(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'name': name,
      'code': code,
    };
  }

  static CurrencyDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return CurrencyDetails(
      symbol: map['symbol'],
      name: map['name'],
      code: map['code'],
    );
  }

  String toJson() => json.encode(toMap());

  static CurrencyDetails? fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'CurrencyDetails symbol: $symbol, name: $name, code: $code';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrencyDetails &&
        other.symbol == symbol &&
        other.name == name &&
        other.code == code;
  }

  @override
  int get hashCode => symbol.hashCode ^ name.hashCode ^ code.hashCode;
}
