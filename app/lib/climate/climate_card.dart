import 'package:flutter/material.dart';
import 'package:pathika/common/info_card.dart';

import 'climate_details.dart';
import 'weather_details.dart';


class ClimateCard extends StatelessWidget {
  final bool useColorsOnCard;
  ClimateCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClimateDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(height: 40);
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.indigo : null,
            heading: 'Climate',
            title: snapshot.data.type,
            footer: WeatherDetails(items: snapshot.data.items),
          );
        }
      },
      initialData: ClimateDetails.empty(),
      future: _getData(context),
    );
  }

  Future<ClimateDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/climate.json")
        .then((source) => Future.value(ClimateDetails.fromJson(source)));
  }
}
