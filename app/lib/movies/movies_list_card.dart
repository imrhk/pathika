import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'movie_item_card.dart';
import 'movie_list.dart';

class MoviesListCard extends StatelessWidget implements Details<MovieList> {
  final bool useColorsOnCard;
  final MovieList details;
  final String countryName;
  MoviesListCard({
    Key key,
    this.useColorsOnCard,
    this.details,
    this.countryName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    assert(useColorsOnCard != null && details != null);
    return InfoCard(
      color: useColorsOnCard ? Colors.indigo : null,
      heading: '${BlocProvider.of<LocalizationBloc>(context).localize('movies_from', 'Movies from')} $countryName',
      body: Container(
        height: 250,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(0),
          shrinkWrap: false,
          itemBuilder: (ctx, index) {
            final item = details.items[index];
            return MovieItemCard(
              name: item.title,
              posterUrl: item.posterUrl,
              cardColor: Theme.of(context).brightness == Brightness.dark || useColorsOnCard ? Colors.transparent : null,
            );
          },
          itemCount: details.items.length,
        ),
      ),
    );
  }
}
