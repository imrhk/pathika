import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'time_to_visit_details.dart';

class TimeToVisitCard extends StatelessWidget {
  final bool useColorsOnCard;
  final TimeToVisitDetails details;
  TimeToVisitCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.amber : null,
      heading: 'Best Time to Visit',
      title: details.primary,
      subtitle: 'or ${details.secondary}',
    );
  }
}
