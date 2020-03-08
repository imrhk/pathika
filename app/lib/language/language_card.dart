import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../localization/localization.dart';
import 'language_details.dart';

class LanguageCard extends StatelessWidget {
  final bool useColorsOnCard;
  final LanguageDetails details;
  LanguageCard({
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
          .localize('language', 'Language'),
      title: details.primary,
      subtitle: details.secondary.join(','),
    );
  }
}
