import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'dance_details.dart';

class DanceCard extends StatelessWidget {
  final bool useColorsOnCard;
  DanceCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
   @override
  Widget build(BuildContext context) {
    return FutureBuilder<DanceDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(height: 40);
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.red : null,
            heading: 'Dance',
            title: snapshot.data.title,
          );
        }
      },
      initialData: DanceDetails.empty(),
      future: _getData(context),
    );
  }

  Future<DanceDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/dance.json")
        .then((source) => Future.value(DanceDetails.fromJson(source)));
  }
}