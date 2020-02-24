import 'package:flutter/material.dart';

import '../common/attributions.dart';

class FoodItemCard extends StatelessWidget {
  final String label;
  final String photoUrl;
  final bool isVeg;
  final bool isNonVeg;
  final String photoBy;
  final String licence;
  final String attributionUrl;
  final Color cardColor;
  const FoodItemCard(
      {Key key,
      this.label,
      this.photoUrl,
      this.isVeg = true,
      this.isNonVeg = true,
      this.photoBy,
      this.licence,
      this.attributionUrl,
      this.cardColor = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 250,
        height: 200,
        child: Stack(
          children: [
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Image.network(
                photoUrl,
                fit: BoxFit.fitWidth,
                width: 250,
                height: 150,
              ),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  label,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              if (photoBy != null && photoBy != "")
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: getAttributionWidget(
                        context, photoBy, attributionUrl, licence)),
            ]),
            Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(
                right: 4,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (isVeg)
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 5,
                    ),
                  if (isNonVeg)
                    SizedBox(
                      width: 8,
                    ),
                  if (isNonVeg)
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 5,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
