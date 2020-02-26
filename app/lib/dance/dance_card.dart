import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'dance_details.dart';

class DanceCard extends StatelessWidget {
  final bool useColorsOnCard;
  final DanceDetails details;
  DanceCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.red : null,
      heading: 'Dance',
      title: details.title,
    );
  }
}
