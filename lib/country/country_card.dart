import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'country_details.dart';

class CountryCard extends StatelessWidget {
  final bool useColorsOnCard;
  CountryCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
   @override
  Widget build(BuildContext context) {
    return FutureBuilder<CountryDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.amber : null,
            heading: 'Country',
            title: snapshot.data.name,
            subtitle: snapshot.data.continent,
          );
        }
      },
      initialData: CountryDetails.empty(),
      future: _getData(context),
    );
  }

  Future<CountryDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/country.json")
        .then((source) => Future.value(CountryDetails.fromJson(source)));
  }
}