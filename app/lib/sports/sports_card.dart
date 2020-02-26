import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'sports_details.dart';

class SportsCard extends StatelessWidget {
  final bool useColorsOnCard;
  final SportsDetails details;
  SportsCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.lightBlue : null,
      heading: 'Most Popular Sports',
      title: details.title,
      footer: Text(details.footer),
    );
  }
}
