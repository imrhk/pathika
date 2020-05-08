import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'time_to_visit_details.dart';

class TimeToVisitCard extends StatelessWidget implements Details<TimeToVisitDetails> {
  final bool useColorsOnCard;
  final TimeToVisitDetails details;
  TimeToVisitCard({
    Key key,
    this.useColorsOnCard,
    this.details,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    assert(useColorsOnCard != null && details != null);
    return InfoCard(
      color: useColorsOnCard ? Colors.amber : null,
      heading: BlocProvider.of<LocalizationBloc>(context).localize('best_time_to_visit', 'Best Time to Visit'),
      title: details.primary,
      subtitle: getSubtitle(context),
    );
  }

  String getSubtitle(BuildContext context) {
    if (details.secondary == null || details.secondary.isEmpty) return "";
    return '${BlocProvider.of<LocalizationBloc>(context).localize('_or', 'or')} ${details.secondary}';
  }
}
