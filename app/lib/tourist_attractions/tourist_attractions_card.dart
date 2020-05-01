import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathika/core/utility.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'tourist_attraction_item_card.dart';
import 'tourist_attractions.list.dart';

class TouristAttractionsCard extends StatelessWidget implements Details<TouristAttractionsList>{
  final bool useColorsOnCard;
  final TouristAttractionsList details;
  TouristAttractionsCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? materialBlack : null,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('tourist_attractions', 'Tourist Attractions'),
      body: Container(
        height: 300,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(0),
          shrinkWrap: false,
          itemBuilder: (ctx, index) {
            final item = details.items[index];
            return TouristAttractionItemCard(
              name: item.name,
              posterUrl: item.photos,
              description: item.description,
              attribution: item.htmlAttributions.length > 0
                  ? item.htmlAttributions[0]
                  : null,
                  licence: item.licence,
              cardColor: Theme.of(context).brightness == Brightness.dark ||
                      useColorsOnCard
                  ? Colors.transparent
                  : null,
            );
          },
          itemCount: details.items.length,
        ),
      ),
    );
  }
}
