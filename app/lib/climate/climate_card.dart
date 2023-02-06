import 'package:flutter/material.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../extensions/context_extensions.dart';
import '../models/place_models.dart';
import 'weather_details.dart';

class ClimateCard extends StatelessWidget implements Details<ClimateDetails> {
  @override
  final ClimateDetails details;

  const ClimateCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.indigo,
      heading: context.localize('climate', 'Climate'),
      title: details.type,
      footer: WeatherDetails(items: details.items),
    );
  }
}
