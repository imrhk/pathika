import 'package:flutter/material.dart';
import 'package:pathika/airport/airport_details.dart';

import '../common/info_card.dart';

class AirportCard extends StatelessWidget {
  final bool useColorsOnCard;
  AirportCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
   @override
  Widget build(BuildContext context) {
    return FutureBuilder<AirportDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(height: 40);
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.cyan : null,
            heading: 'Airport',
            title: snapshot.data.name,
          );
        }
      },
      initialData: AirportDetails.empty(),
      future: _getData(context),
    );
  }

  Future<AirportDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/airport.json")
        .then((source) => Future.value(AirportDetails.fromJson(source)));
  }
}