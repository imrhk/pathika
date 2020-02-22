import 'package:flutter/material.dart';

class AttractionItemCard extends StatelessWidget {
  final String name;
  final String posterUrl;
  final String description;
  final Color cardColor;
  const AttractionItemCard(
      {Key key, this.name, this.posterUrl, this.description, this.cardColor = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  image: NetworkImage(
                    posterUrl,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Text(name,
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Text(description ?? "",
                  style: TextStyle(
                    fontSize: 14,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
