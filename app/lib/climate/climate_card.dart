import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'climate_details.dart';
import 'weather_details.dart';

class ClimateCard extends StatelessWidget {
  final bool useColorsOnCard;
  final ClimateDetails details;
  ClimateCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.indigo : null,
      heading: 'Climate',
      title: details.type,
      footer: WeatherDetails(items: details.items),
    );
  }
}
