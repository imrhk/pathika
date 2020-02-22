import 'package:flutter/material.dart';

class PeopleItemCard extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String work;
  final String place;
  PeopleItemCard({
    Key key,
    this.name,
    this.avatarUrl,
    this.work,
    this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget subtitle;
    if (work == null && place == null) {
      subtitle = Container();
    } else if (work == null && place != null) {
      subtitle = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.place, size: 12),
          SizedBox(width: 5),
          Text(
            place,
            softWrap: true,
          )
        ],
      );
    } else if (work != null && place == null) {
      subtitle = Text(work);
    } else {
      subtitle = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(work),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              Icons.place,
              size: 12,
            ),
            SizedBox(width: 5),
            Text(
              place,
              softWrap: true,
            )
          ]),
        ],
      );
    }
    return ListTile(
      title: Text(name),
      isThreeLine: true,
      leading: Image.network(
        avatarUrl,
        fit: BoxFit.scaleDown,
        width: 60,
        height: 60,
      ),
      contentPadding: EdgeInsets.fromLTRB(4, 0, 0, 0),
      subtitle: subtitle,
    );
  }
}
