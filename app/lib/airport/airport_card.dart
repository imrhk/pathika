import 'package:flutter/material.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../extensions/context_extensions.dart';
import '../models/place_models.dart';

class AirportCard extends StatelessWidget implements Details<AirportDetails> {
  @override
  final AirportDetails details;

  const AirportCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.green,
      heading: context.localize('airport', 'Airport'),
      title: details.name,
    );
  }
}
