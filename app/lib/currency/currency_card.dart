import 'dart:io' show HttpClient;

import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'currency_details.dart';
import 'currency_value.dart';

class CurrencyCard extends StatelessWidget {
  final bool useColorsOnCard;
  final CurrencyDetails details;
  final HttpClient httpclient;
  CurrencyCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
    this.httpclient,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.pink : null,
      heading: 'Currency',
      title: details.name,
      symbol: details.symbol,
      footer: CurrencyValue(
        from: details.code,
        symbol: details.symbol,
        httpClient: httpclient,
      ),
    );
  }
}
