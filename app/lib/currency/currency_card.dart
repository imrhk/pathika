import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart' show HttpClient;

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'currency_details.dart';
import 'currency_value.dart';

class CurrencyCard extends StatelessWidget implements Details<CurrencyDetails>{
  final bool useColorsOnCard;
  final CurrencyDetails details;
  final HttpClient httpclient;
  CurrencyCard({
    Key key,
    this.useColorsOnCard,
    this.details,
    this.httpclient,
  })  : super(key: key);
  @override
  Widget build(BuildContext context) {
    assert(useColorsOnCard != null && details != null);
    return InfoCard(
      color: useColorsOnCard ? Colors.pink : null,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('currency', 'Currency'),
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
