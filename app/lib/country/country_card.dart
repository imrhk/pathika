import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'country_details.dart';

class CountryCard extends StatelessWidget {
  final bool useColorsOnCard;
  final CountryDetails details;
  CountryCard({
    Key key,
    @required this.details,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.amber : null,
      heading: 'Country',
      title: details.name,
      subtitle: details.continent,
    );
  }
}
