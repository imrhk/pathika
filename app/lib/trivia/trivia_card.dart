import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathika/localization/localization.dart';

import '../common/info_card.dart';
import 'trivia_list_details.dart';

class TriviaListCard extends StatelessWidget {
  final bool useColorsOnCard;
  final TriviaListDetails details;
  TriviaListCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);

  List<Widget> getChildren(BuildContext context, List<String> triviaList) {
    List list = triviaList
        .map<Widget>(
          (item) => ListTile(
            title: Text(item),
            leading: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.05),
              foregroundColor: Theme.of(context).textTheme.subtitle1.color,
              radius: 20,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  '#${triviaList.indexOf(item) + 1}',
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(0),
          ),
        )
        .map<List<Widget>>((item) => [
              item,
              Divider(
                thickness: 2,
              )
            ])
        .toList()
        .expand((element) => element)
        .toList();
    if (list.length > 0) {
      list.removeLast();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.blueGrey : null,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('trivia', 'Trivia'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: getChildren(context, details.items),
      ),
    );
  }
}
