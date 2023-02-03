import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../localization/localization.dart';
import '../models/place_models.dart';

class DanceCard extends StatelessWidget {
  final DanceDetails details;
  const DanceCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.red,
      heading:
          BlocProvider.of<LocalizationBloc>(context).localize('dance', 'Dance'),
      title: details.title,
    );
  }
}
