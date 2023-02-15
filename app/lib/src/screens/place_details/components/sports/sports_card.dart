import 'package:flutter/material.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../../../models/place_models/place_models.dart';
import '../../widgets/info_card.dart';

class SportsCard extends StatelessWidget implements Details<SportsDetails> {
  @override
  final SportsDetails details;
  const SportsCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.lightBlue,
      heading: context.localize('most_popular_sports', 'Most Popular Sports'),
      title: details.title ?? '',
      footer: Text(details.footer ?? ''),
    );
  }
}
