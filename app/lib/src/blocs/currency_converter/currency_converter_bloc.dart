import 'dart:convert';
import 'dart:ui';

import 'package:intl/intl.dart';

import '../../constants/localization_constants.dart';
import '../../data/remote/remote_repository.dart';
import '../../models/currency_conversion_item/currency_conversion_item.dart';
import '../page_fetch/page_fetch_bloc.dart';
import 'convert_currency_event.dart';

class CurrencyConverterBloc
    extends PageFetchBloc<ConvertCurrencyEvent, ConversionItem?> {
  final RemoteRepository _remoteRepository;

  CurrencyConverterBloc(this._remoteRepository);

  @override
  Future<ConversionItem?> fetchPage(ConvertCurrencyEvent event) async {
    var from = await _fromCurrency(event.from, event.language);
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

  Future<String> _fromCurrency(String? fromCurrency, String? language) async {
    if (fromCurrency == null || fromCurrency.isEmpty) {
      final country = await _remoteRepository.getUserCountry();
      final countryCode = country.code;
      final locale = Locale(language ?? localeDefault, countryCode);
      print(locale);
      final numberFormat = NumberFormat.simpleCurrency(
          locale: locale.toString(), decimalDigits: 2);
      return Future.value(numberFormat.currencyName);
    } else {
      return Future.value(fromCurrency);
    }
  }
}
