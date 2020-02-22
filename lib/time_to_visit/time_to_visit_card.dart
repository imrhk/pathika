import 'package:flutter/material.dart';
import 'package:pathika/time_to_visit/time_to_visit_details.dart';

import '../common/info_card.dart';

class TimeToVisitCard extends StatelessWidget {
  final bool useColorsOnCard;
  TimeToVisitCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
   @override
  Widget build(BuildContext context) {
    return FutureBuilder<TimeToVisitDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.amber : null,
            heading: 'Best Time to Visit',
            title: snapshot.data.primary,
            subtitle: 'or ${snapshot.data.secondary}',
          );
        }
      },
      initialData: TimeToVisitDetails.empty(),
      future: _getData(context),
    );
  }

  Future<TimeToVisitDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/time_to_visit.json")
        .then((source) => Future.value(TimeToVisitDetails.fromJson(source)));
  }
}