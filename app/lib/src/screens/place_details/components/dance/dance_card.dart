import 'package:flutter/material.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../../../models/place_models/place_models.dart';
import '../../widgets/info_card.dart';

class DanceCard extends StatelessWidget implements Details<DanceDetails> {
  @override
  final DanceDetails details;
  const DanceCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.red,
      heading: context.l10n.dance,
      title: details.title,
    );
  }
}
