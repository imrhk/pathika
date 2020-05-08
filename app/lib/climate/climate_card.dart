import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'climate_details.dart';
import 'weather_details.dart';

class ClimateCard extends StatelessWidget implements Details<ClimateDetails> {
  final bool useColorsOnCard;
  final ClimateDetails details;
  
  ClimateCard({
    Key key,
    this.useColorsOnCard,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(useColorsOnCard != null && details != null);
    return InfoCard(
      color: useColorsOnCard ? Colors.indigo : null,
      heading: BlocProvider.of<LocalizationBloc>(context).localize('climate', 'Climate'),
      title: details.type,
      footer: WeatherDetails(items: details.items),
    );
  }
}
