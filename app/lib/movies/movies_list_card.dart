import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'movie_item_card.dart';
import 'movie_list.dart';

class MoviesListCard extends StatelessWidget {
  final bool useColorsOnCard;
  final MovieList details;
  MoviesListCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.indigo : null,
      heading: 'Movies from Argentina',
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
