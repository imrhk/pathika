import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'sports_details.dart';


class SportsCard extends StatelessWidget {
  final bool useColorsOnCard;
  SportsCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
   @override
  Widget build(BuildContext context) {
    return FutureBuilder<SportsDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(height: 40);
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.lightBlue : null,
            heading: 'Most Popular Sports',
            title: snapshot.data.title,
            footer: Text(snapshot.data.footer),
          );
        }
      },
      initialData: SportsDetails.empty(),
      future: _getData(context),
    );
  }

  Future<SportsDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/sports.json")
        .then((source) => Future.value(SportsDetails.fromJson(source)));
  }
}