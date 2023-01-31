import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'sports_details.dart';

class SportsCard extends StatelessWidget implements Details<SportsDetails> {
  @override
  final SportsDetails details;
  const SportsCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.lightBlue,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('most_popular_sports', 'Most Popular Sports'),
      title: details.title ?? '',
      footer: Text(details.footer ?? ''),
    );
  }
}
