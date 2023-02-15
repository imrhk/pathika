import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_conversion_item.freezed.dart';
part 'currency_conversion_item.g.dart';

@freezed
class ConversionItem with _$ConversionItem {
  const factory ConversionItem({
    required String from,
    required String to,
    required double value,
    required int quantity,
  }) = _ConversionItem;

  factory ConversionItem.fromJson(Map<String, dynamic> json) =>
      _$ConversionItemFromJson(json);
}
