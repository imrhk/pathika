import 'package:flutter/material.dart';
import 'package:pathika/tourist_attractions/tourist_attractions.list.dart';

import '../common/info_card.dart';
import 'tourist_attraction_item_card.dart';

class TouristAttractionsCard extends StatelessWidget {
  final bool useColorsOnCard;
  TouristAttractionsCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TouristAttractionsList>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.green : null,
            heading: 'Tourist Attractions',
            body: Container(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final item = snapshot.data.items[index];
                  return TouristAttractionItemCard(
                    name: item.name,
                    posterUrl: item.photos,
                    description: item.description,
                    attribution: item.htmlAttributions.length > 0 ? item.htmlAttributions[0] : null,
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
      initialData: TouristAttractionsList.empty(),
      future: _getData(context),
    );
  }

  Future<TouristAttractionsList> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/tourist_places.json")
        .then(
            (source) => Future.value(TouristAttractionsList.fromJson(source)));
  }
}
