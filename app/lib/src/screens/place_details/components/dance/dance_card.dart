import 'package:flutter/material.dart';

import '../../../../extensions/context_extensions.dart';
import '../../../../models/place_models/place_models.dart';
import '../../widgets/info_card.dart';

// FIXME: detailable?
class DanceCard extends StatelessWidget {
  final DanceDetails details;
  const DanceCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.red,
      heading: context.localize('dance', 'Dance'),
      title: details.title,
    );
  }
}
