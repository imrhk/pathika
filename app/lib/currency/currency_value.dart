import 'dart:convert';
import 'package:universal_io/io.dart' show HttpClient;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pathika/currency/conversion_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pathika/app_language/select_language_page.dart';
import 'package:pathika/core/repository.dart';

class CurrencyValue extends StatelessWidget {
  final String from;
  final String symbol;
  final HttpClient httpClient;

  const CurrencyValue({Key key, this.from, this.symbol, this.httpClient})
      : super(key: key);

  //'TO' is left , 'From' is right.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConversionItem>(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text(
            ' ',
            style : TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.end,
          );
        } else {
          final conversionItem = snapshot.data;
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
            style: TextStyle(
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

  Future<Locale> getAppLocale() async {
    Future<String> countryCode = Repository.getResponse(
      httpClient: httpClient,
      url: 'https://freegeoip.live/json/',
      cacheTime: Duration(days: 7),
    )
        .then((response) => json.decode(response))
        .then((map) => map['country_code']);
    Future<String> languageCode = SharedPreferences.getInstance()
        .then((sharedPref) => sharedPref.getString(APP_LANGUAGE));

    return Future.wait<String>([
      languageCode,
      countryCode,
    ]).then((value) => Locale(value[0], value[1]));
  }

  Future<ConversionItem> _getData(BuildContext context) async {
    Future numberFormatForUserCurrency = getAppLocale().then((locale) =>
        NumberFormat.simpleCurrency(
            locale: locale.toString(), decimalDigits: 2));
    Future value = numberFormatForUserCurrency
        .then(
          (numberFormat) => Repository.getResponse(
            httpClient: httpClient,
            url:
                'https://free.currconv.com/api/v7/convert?q=$from\_${numberFormat.currencyName}&compact=ultra&apiKey=7fe0bb93f75ab677bafa',
            cacheTime: Duration(days: 1),
          ),
        )
        .then((response) => json.decode(response))
        .then((jsonResponse) => (jsonResponse as Map))
        .then((map) => map.values.first as double);

    Future userCurrency =
        numberFormatForUserCurrency.then((value) => value.currencyName);

    return Future.wait([value, userCurrency]).then(
      (value) {
        int quantity = 1;
        double v = value[0];
        while (v < 1.0) {
          quantity *= 10;
          v *= 10;
        }
        return ConversionItem(
          from: this.from,
          to: value[1],
          value: value[0],
          quantity: quantity,
        );
      },
    );
  }
}
