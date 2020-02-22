import 'package:flutter/material.dart';

class FoodItemCard extends StatelessWidget {
  final String url;
  final String label;
  final bool isVeg;
  final bool isNonVeg;

  const FoodItemCard(
      {Key key,
      this.url,
      this.label,
      this.isVeg = false,
      this.isNonVeg = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Image.network(
                url,
                fit: BoxFit.fill,
                width: 150,
                height: 100,
              ),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  label,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
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
