import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'industry_details.dart';

class IndustriesCard extends StatelessWidget {
  final bool useColorsOnCard;
  IndustriesCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
   @override
  Widget build(BuildContext context) {
    return FutureBuilder<IndustryDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(height: 40);
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.yellow : null,
            heading: 'Industries',
            title: snapshot.data.primary,
            subtitle: snapshot.data.secondary.join(','),
          );
        }
      },
      initialData: IndustryDetails.empty(),
      future: _getData(context),
    );
  }

  Future<IndustryDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/industries.json")
        .then((source) => Future.value(IndustryDetails.fromJson(source)));
  }
}