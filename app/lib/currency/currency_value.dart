import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../common/constants.dart';
import 'package:universal_io/io.dart' show HttpClient;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'conversion_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_language/select_language_page.dart';
import '../core/repository.dart';

class CurrencyValue extends StatelessWidget {
  final String from;
  final String symbol;
  final HttpClient httpClient;

  const CurrencyValue({
    super.key,
    required this.from,
    required this.symbol,
    required this.httpClient,
  });

  //'TO' is left , 'From' is right.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConversionItem?>(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error.toString());
          }
          return const Text(
            ' ',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.end,
          );
        } else {
          final conversionItem = snapshot.data;
          if (conversionItem == null || conversionItem.quantity == 0) {
            return const SizedBox.shrink();
          }
          final symbolTo = NumberFormat.simpleCurrency(name: conversionItem.to);
          final symbolFrom =
              NumberFormat.simpleCurrency(name: conversionItem.from);
          final quantity = conversionItem.quantity;
          final valueTo = conversionItem.value * quantity;
          final valueFrom = quantity;
          final currencySymbolTextTo =
              symbolTo.currencySymbol == symbolFrom.currencySymbol
                  ? conversionItem.to
                  : symbolTo.currencySymbol;
          final currencySymbolTextFrom =
              symbolTo.currencySymbol == symbolFrom.currencySymbol
                  ? conversionItem.from
                  : symbolFrom.currencySymbol;

          return Text(
            '$currencySymbolTextFrom ${valueFrom.toStringAsFixed(2)} = $currencySymbolTextTo ${valueTo.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.end,
          );
        }
      },
      initialData: ConversionItem.empty(),
      future: _getData(context),
    );
  }

  Future<Locale?> getAppLocale() async {
    Future<String?> countryCode = Repository.getResponse(
      httpClient: httpClient,
      url: 'http://ip-api.com/json/',
      cacheTime: const Duration(days: 7),
    )
        .then((response) => json.decode(response ?? '{}'))
        .then((map) => map['countryCode'] as String?)
        .onError<String>((error, stackTrace) => null);
    Future<String?> languageCode = SharedPreferences.getInstance()
        .then((sharedPref) => sharedPref.getString(appLanguage) ?? "en");

    return Future.wait<String?>([
      languageCode,
      countryCode,
    ]).then((value) {
      if (value.length == 2 && value[0] != null && value[1] != null) {
        return Locale(value[0]!, value[1]!);
      }
      return null;
    });
  }

  Future<ConversionItem?> _getData(BuildContext context) async {
    final locale = await getAppLocale();
    if (locale == null) {
      return null;
    }

    final numberFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
    final response = await Repository.getResponse(
      httpClient: httpClient,
      url: '$apiUrl/convertCurrency?from=$from&to=${numberFormat.currencyName}',
      cacheTime: const Duration(days: 1),
    );
    if (response == null) {
      return null;
    }

    final Map jsonResponse = json.decode(response);
    var value = jsonResponse.values.first as double;

    final userCurrency = numberFormat.currencyName;
    if (userCurrency == null) {
      return null;
    }

    int quantity = 1;
    while (value < 1.0) {
      quantity *= 10;
      value *= 10;
    }
    return ConversionItem(
      from: from,
      to: userCurrency,
      value: value,
      quantity: quantity,
    );
  }
}
