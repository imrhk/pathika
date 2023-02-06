import 'package:flutter/material.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../extensions/context_extensions.dart';
import '../models/place_models.dart';

class TimeToVisitCard extends StatelessWidget
    implements Details<TimeToVisitDetails> {
  @override
  final TimeToVisitDetails details;
  const TimeToVisitCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.amber,
      heading: context.localize('best_time_to_visit', 'Best Time to Visit'),
      title: details.primary,
      subtitle: getSubtitle(context),
    );
  }

  String getSubtitle(BuildContext context) {
    if (details.secondary?.isEmpty ?? true) return "";
    return '${context.localize('_or', 'or')} ${details.secondary}';
  }
}
