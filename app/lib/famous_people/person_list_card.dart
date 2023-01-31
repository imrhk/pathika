import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import './person_list.dart';
import './person_tile.dart';

class PersonListCard extends StatelessWidget implements Details<PersonList> {
  @override
  final PersonList details;
  const PersonListCard({
    super.key,
    required this.details,
  });

  List<Widget> getChildren(PersonList personList) {
    final list = personList.items
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
