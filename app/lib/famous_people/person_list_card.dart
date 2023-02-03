import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import '../models/place_models.dart';
import 'person_tile.dart';

class PersonListCard extends StatelessWidget
    implements Details<List<PersonDetails>> {
  @override
  final List<PersonDetails> details;
  const PersonListCard({
    super.key,
    required this.details,
  });

  List<Widget> getChildren(List<PersonDetails> personList) {
    final list = personList
        .map<Widget>(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: PersonTile(
              name: item.name,
              avatarUrl: item.avatarUrl,
              work: item.work,
              place: item.place,
              attributionUrl: item.attributionUrl,
              licence: item.licence,
              photoBy: item.photoBy,
            ),
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
      color: Colors.cyan,
      heading: BlocProvider.of<LocalizationBloc>(context)
          .localize('famous_people', 'Famous People'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: getChildren(details),
      ),
    );
  }
}
