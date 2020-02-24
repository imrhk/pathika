import 'package:flutter/material.dart';
import 'package:pathika/famous_people/person_list.dart';
import 'package:pathika/famous_people/person_tile.dart';

import '../common/info_card.dart';

class PersonListCard extends StatelessWidget {
  final bool useColorsOnCard;
  PersonListCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);

  List<Widget> getChildren(PersonList personList) {
    final list =  personList.items
        .map<Widget>(
          (item) => Padding( padding: EdgeInsets.symmetric(vertical: 5),
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
        .map<List<Widget>>((item) => [item, Divider(thickness: 2,)])
        .toList()
        .expand((element) => element)
        .toList();
    if(list.length > 0) {
      list.removeLast();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PersonList>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.cyan : null,
            heading: 'Famous People',
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: getChildren(snapshot.data),
            ),
          );
        }
      },
      initialData: PersonList.empty(),
      future: _getData(context),
    );
  }

  Future<PersonList> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/persons.json")
        .then((source) => Future.value(PersonList.fromJson(source)));
  }
}
