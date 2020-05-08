import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'country_details.dart';

class CountryCard extends StatelessWidget implements Details<CountryDetails>{
  final bool useColorsOnCard;
  final CountryDetails details;
  CountryCard({
    Key key,
    this.details,
    this.useColorsOnCard,
  })  : super(key: key);
  @override
  Widget build(BuildContext context) {
    assert(useColorsOnCard != null && details != null);
    return InfoCard(
      color: useColorsOnCard ? Colors.amber : null,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('country', 'Country'),
      title: details.name,
      subtitle: details.continent,
    );
  }
}
