import 'package:flutter/material.dart';
import 'package:pathika/movies/movie_item_card.dart';
import 'package:pathika/movies/movie_list.dart';

import '../common/info_card.dart';

class MoviesListCard extends StatelessWidget {
  final bool useColorsOnCard;
  MoviesListCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieList>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(height: 40);
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.indigo : null,
            heading: 'Movies from Argentina',
            body: Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final item = snapshot.data.items[index];
                  return MovieItemCard(
                    name: item.title,
                    posterUrl: item.posterUrl,
                    cardColor:
                        Theme.of(context).brightness == Brightness.dark ||
                                useColorsOnCard
                            ? Colors.transparent
                            : null,
                  );
                },
                itemCount: snapshot.data.items.length,
              ),
            ),
          );
        }
      },
      initialData: MovieList.empty(),
      future: _getData(context),
    );
  }

  Future<MovieList> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/movies.json")
        .then((source) => Future.value(MovieList.fromJson(source)));
  }
}
