import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../localization/localization.dart';
import 'dance_details.dart';

class DanceCard extends StatelessWidget {
  final bool useColorsOnCard;
  final DanceDetails details;
  DanceCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.red : null,
      heading: BlocProvider.of<LocalizationBloc>(context).localize('dance', 'Dance'),
      title: details.title,
    );
  }
}
