import 'package:flutter/material.dart';

import '../widgets/attribution_widget.dart';

class FoodItemCard extends StatelessWidget {
  final String label;
  final String? photoUrl;
  final bool isVeg;
  final bool isNonVeg;
  final String? photoBy;
  final String? licence;
  final String? attributionUrl;
  const FoodItemCard({
    super.key,
    required this.label,
    required this.photoUrl,
    this.isVeg = true,
    this.isNonVeg = true,
    required this.photoBy,
    required this.licence,
    required this.attributionUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 250,
        height: 200,
        child: Stack(
          children: [
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (photoUrl != null)
                    AspectRatio(
                      aspectRatio: 5 / 3,
                      child: Image.network(
                        photoUrl!,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      label,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (photoBy != "")
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      child: AttributionWidget(
                        photoBy: photoBy,
                        attributionUrl: attributionUrl,
                        licence: licence,
                      ),
                    ),
                ]),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(
                right: 4,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (isVeg)
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 5,
                    ),
                  if (isNonVeg)
                    const SizedBox(
                      width: 8,
                    ),
                  if (isNonVeg)
                    const CircleAvatar(
                      backgroundColor: Colors.brown,
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
