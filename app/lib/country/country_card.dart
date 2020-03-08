import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../localization/localization.dart';
import 'country_details.dart';

class CountryCard extends StatelessWidget {
  final bool useColorsOnCard;
  final CountryDetails details;
  CountryCard({
    Key key,
    @required this.details,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.amber : null,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('country', 'Country'),
      title: details.name,
      subtitle: details.continent,
    );
  }
}
