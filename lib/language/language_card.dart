import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'language_details.dart';

class LanguageCard extends StatelessWidget {
  final bool useColorsOnCard;
  LanguageCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
   @override
  Widget build(BuildContext context) {
    return FutureBuilder<LanguageDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.lightBlue : null,
            heading: 'Country',
            title: snapshot.data.primary,
            subtitle: snapshot.data.secondary.join(','),
          );
        }
      },
      initialData: LanguageDetails.empty(),
      future: _getData(context),
    );
  }

  Future<LanguageDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/language.json")
        .then((source) => Future.value(LanguageDetails.fromJson(source)));
  }
}