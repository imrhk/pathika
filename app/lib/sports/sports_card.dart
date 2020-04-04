import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'sports_details.dart';

class SportsCard extends StatelessWidget implements Details<SportsDetails> {
  final bool useColorsOnCard;
  final SportsDetails details;
  SportsCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.lightBlue : null,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('most_popular_sports', 'Most Popular Sports'),
      title: details.title,
      footer: Text(details.footer),
    );
  }
}
