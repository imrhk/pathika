import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'airport_details.dart';

class AirportCard extends StatelessWidget {
  final bool useColorsOnCard;
  final AirportDetails details;
  AirportCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.cyan : null,
      heading: 'Airport',
      title: details.name,
    );
  }
}
