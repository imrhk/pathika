import 'package:flutter/material.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../../../models/place_models/place_models.dart';
import '../../widgets/info_card.dart';
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
      heading: context.l10n.climate,
      title: details.type,
      footer: WeatherDetails(items: details.items),
    );
  }
}
