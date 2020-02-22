import 'package:flutter/material.dart';

class MovieItemCard extends StatelessWidget {
  final String name;
  final String posterUrl;

  const MovieItemCard({Key key, this.name, this.posterUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
