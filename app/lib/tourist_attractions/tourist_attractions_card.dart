import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../core/utility.dart';
import '../localization/localization.dart';
import '../models/place_models.dart';
import 'tourist_attraction_item_card.dart';

class TouristAttractionsCard extends StatelessWidget
    implements Details<List<TouristAttractionDetails>> {
  @override
  final List<TouristAttractionDetails> details;
  const TouristAttractionsCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: materialBlack,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('tourist_attractions', 'Tourist Attractions'),
      body: SizedBox(
        height: 300,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(0),
          shrinkWrap: false,
          itemBuilder: (ctx, index) {
            final item = details[index];
            firstAttribution() {
              final attributions = item.attributionUrl;
              if (attributions == null || attributions.isEmpty) {
                return null;
              } else {
                return attributions.first;
              }
            }

            return TouristAttractionItemCard(
              name: item.name,
              posterUrl: item.photos,
              description: item.description,
              attribution: firstAttribution(),
              licence: item.licence,
            );
          },
          itemCount: details.length,
        ),
      ),
    );
  }
}
