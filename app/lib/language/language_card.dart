import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'language_details.dart';

class LanguageCard extends StatelessWidget {
  final bool useColorsOnCard;
  final LanguageDetails details;
  LanguageCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.lightBlue : null,
      heading: 'Language',
      title: details.primary,
      subtitle: details.secondary.join(','),
    );
  }
}
