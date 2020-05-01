import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'airport_details.dart';

class AirportCard extends StatelessWidget implements Details<AirportDetails>{
  final bool useColorsOnCard;
  final AirportDetails details;
  AirportCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.green : null,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('airport', 'Airport'),
      title: details.name,
    );
  }
}
