import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../localization/localization.dart';
import 'movie_item_card.dart';
import 'movie_list.dart';

class MoviesListCard extends StatelessWidget {
  final bool useColorsOnCard;
  final MovieList details;
  final String countryName;
  MoviesListCard(
      {Key key,
      @required this.useColorsOnCard,
      @required this.details,
      this.countryName})
      : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.indigo : null,
      heading:
          '${BlocProvider.of<LocalizationBloc>(context).localize('movies_from', 'Movies from')} $countryName',
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
