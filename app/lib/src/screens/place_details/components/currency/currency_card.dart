import 'package:flutter/material.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../../../models/place_models/place_models.dart';
import '../../widgets/info_card.dart';
import 'currency_value.dart';

class CurrencyCard extends StatelessWidget implements Details<CurrencyDetails> {
  @override
  final CurrencyDetails details;
  const CurrencyCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.pink,
      heading: context.localize('currency', 'Currency'),
      title: details.name,
      symbol: details.symbol,
      footer: CurrencyValue(
        to: details.code,
        symbol: details.symbol,
      ),
    );
  }
}
