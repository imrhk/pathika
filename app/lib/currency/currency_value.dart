import 'package:flutter/material.dart';
import 'package:pathika/currency/conversion_details.dart';

class CurrencyValue extends StatelessWidget {
  final String from;
  final String to;
  final String symbol;

  const CurrencyValue({Key key, this.from, this.to, this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConversionDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          final value = snapshot.data.items.firstWhere((element) => element.from == from && element.to == to).value;
          return Text(
            '${symbol}1 = ₹${value.toStringAsPrecision(2)}',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.end,
          );
        }
      },
      initialData: ConversionDetails.empty(),
      future: _getData(context),
    );
  }

  Future<ConversionDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/currency_conversion.json")
        .then((source) => Future.value(ConversionDetails.fromJson(source)));
  }
}
