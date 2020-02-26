import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'industry_details.dart';

class IndustriesCard extends StatelessWidget {
  final bool useColorsOnCard;
  final IndustryDetails details;
  IndustriesCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.yellow : null,
      heading: 'Industries',
      title: details.primary,
      subtitle: details.secondary.join(','),
    );
  }
}
