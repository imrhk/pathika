import 'package:flutter/material.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../extensions/context_extensions.dart';
import '../models/place_models.dart';

class CountryCard extends StatelessWidget implements Details<CountryDetails> {
  @override
  final CountryDetails details;
  const CountryCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.amber,
      heading: context.localize('country', 'Country'),
      title: details.name,
      subtitle: details.continent,
    );
  }
}
