import 'dart:convert';
import 'dart:ui';

import 'package:intl/intl.dart';

import '../page_fetch/page_fetch_bloc.dart';
import '../remote/remote_repository.dart';
import 'conversion_item.dart';
import 'convert_currency_event.dart';

class CurrencyConverterBloc
    extends PageFetchBloc<ConvertCurrencyEvent, ConversionItem?> {
  final RemoteRepository _remoteRepository;

  CurrencyConverterBloc(this._remoteRepository);

  @override
  Future<ConversionItem?> fetchPage(ConvertCurrencyEvent event) async {
    var from = event.from;
    if (from == null || from.isEmpty) {
      final country = await _remoteRepository.getUserCountry();
      final countryCode = country.code;
      final locale = Locale(event.language ?? 'en', countryCode);
      final numberFormat = NumberFormat.simpleCurrency(
          locale: locale.toString(), decimalDigits: 2);
      from = numberFormat.currencyName;
    }
    if (from != null && from.isNotEmpty) {
      final response =
          await _remoteRepository.getCurrencyConversionRate(from, event.to);
      final Map jsonResponse = json.decode(response);
      var value = jsonResponse.values.first as double;

      int quantity = 1;
      while (value < 1.0) {
        quantity *= 10;
        value *= 10;
      }
      return ConversionItem(
        from: from,
        to: event.to,
        value: value,
        quantity: quantity,
      );
    }
    throw Exception("Couldn't fetch conversion");
  }
}
