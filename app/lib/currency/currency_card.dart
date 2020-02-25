import 'package:flutter/material.dart';
import 'package:pathika/currency/currency_value.dart';

import '../common/info_card.dart';
import 'currency_details.dart';

class CurrencyCard extends StatelessWidget {
  final bool useColorsOnCard;
  CurrencyCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CurrencyDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(height: 40);
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.pink : null,
            heading: 'Currency',
            title: snapshot.data.name,
            symbol: snapshot.data.symbol,
            footer: CurrencyValue(from: "ARS", to: "INR", symbol: "\$",),
          );
        }
      },
      initialData: CurrencyDetails.empty(),
      future: _getData(context),
    );
  }

  Future<CurrencyDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/currency.json")
        .then((source) => Future.value(CurrencyDetails.fromJson(source)));
  }
}
