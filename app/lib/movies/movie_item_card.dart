import 'package:flutter/material.dart';

class MovieItemCard extends StatelessWidget {
  final String name;
  final String? posterUrl;
  final Color cardColor;

  const MovieItemCard({
    super.key,
    required this.name,
    this.posterUrl,
    this.cardColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (posterUrl != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    image: NetworkImage(
                      posterUrl!,
                    ),
                  ),
                ),
              ),
            if (posterUrl == null)
              const SizedBox(
                height: 200,
              ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  name,
                  style: const TextStyle(
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
