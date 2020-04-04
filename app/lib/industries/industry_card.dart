import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'industry_details.dart';

class IndustriesCard extends StatelessWidget implements Details<IndustryDetails>{
  final bool useColorsOnCard;
  final IndustryDetails details;
  IndustriesCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.yellow : null,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('industries', 'Industries'),
      title: details.primary,
      subtitle: details.secondary.join(','),
    );
  }
}
