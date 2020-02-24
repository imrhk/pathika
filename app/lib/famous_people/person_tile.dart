import 'package:flutter/material.dart';

import '../common/attributions.dart';

class PersonTile extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String work;
  final String place;
  final String photoBy;
  final String licence;
  final String attributionUrl;

  PersonTile({
    Key key,
    this.name,
    this.avatarUrl,
    this.work,
    this.place,
    this.photoBy,
    this.licence,
    this.attributionUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              image: NetworkImage(
                avatarUrl,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                ),
                softWrap: true,
              ),
              SizedBox(height: 5),
              Text(
                work,
                softWrap: true,
              ),
              if (place != null && place.isNotEmpty) SizedBox(height: 5),
              if (place != null && place.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.place,
                      size: 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      place,
                      softWrap: true,
                    )
                  ],
                ),
              if (photoBy != null && photoBy != "")
                SizedBox(
                  height: 5,
                ),
              if (photoBy != null && photoBy != "")
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4,),
                  child: getAttributionWidget(
                      context, photoBy, attributionUrl, licence),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
