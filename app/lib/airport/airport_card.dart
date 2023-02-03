import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
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
      heading: context.read<LocalizationBloc>().localize('airport', 'Airport'),
      title: details.name,
    );
  }
}
