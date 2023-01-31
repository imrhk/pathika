import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'language_details.dart';

class LanguageCard extends StatelessWidget implements Details<LanguageDetails> {
  @override
  final LanguageDetails details;
  const LanguageCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.lightBlue,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('language', 'Language'),
      title: details.primary,
      subtitle: details.secondary.join(','),
    );
  }
}
