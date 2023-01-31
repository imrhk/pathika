import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'airport_details.dart';

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
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('airport', 'Airport'),
      title: details.name,
    );
  }
}
