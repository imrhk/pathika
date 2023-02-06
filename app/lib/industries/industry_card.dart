import 'package:flutter/material.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../extensions/context_extensions.dart';
import '../models/place_models.dart';

class IndustriesCard extends StatelessWidget
    implements Details<IndustryDetails> {
  @override
  final IndustryDetails details;
  const IndustriesCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.yellow,
      heading: context.localize('industries', 'Industries'),
      title: details.primary,
      subtitle: details.secondary?.join(',') ?? '',
    );
  }
}
