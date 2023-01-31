import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'industry_details.dart';

class IndustriesCard extends StatelessWidget
    implements Details<IndustryDetails> {
  @override
  final IndustryDetails details;
  const IndustriesCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.yellow,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('industries', 'Industries'),
      title: details.primary,
      subtitle: details.secondary?.join(',') ?? '',
    );
  }
}
