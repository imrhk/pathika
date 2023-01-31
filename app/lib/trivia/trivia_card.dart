import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'trivia_list_details.dart';

class TriviaListCard extends StatelessWidget
    implements Details<TriviaListDetails> {
  @override
  final TriviaListDetails details;
  const TriviaListCard({
    super.key,
    required this.details,
  });

  List<Widget> getChildren(BuildContext context, List<String> triviaList) {
    List<Widget> list = triviaList
        .map<Widget>(
          (item) => ListTile(
            title: Text(item),
            leading: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.05),
              foregroundColor: Theme.of(context).textTheme.titleMedium?.color,
              radius: 20,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  '#${triviaList.indexOf(item) + 1}',
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(0),
          ),
        )
        .map<List<Widget>>((item) => [
              item,
              const Divider(
                thickness: 2,
              )
            ])
        .toList()
        .expand((element) => element)
        .toList();
    if (list.isNotEmpty) {
      list.removeLast();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.blueGrey,
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
