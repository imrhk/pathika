import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart' show HttpClient;

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import './currency_details.dart';
import './currency_value.dart';

class CurrencyCard extends StatelessWidget implements Details<CurrencyDetails> {
  @override
  final CurrencyDetails details;
  final HttpClient httpclient;
  const CurrencyCard({
    super.key,
    required this.details,
    required this.httpclient,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.pink,
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
