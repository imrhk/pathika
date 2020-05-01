import 'package:flutter/material.dart';
import 'package:pathika/common/attributions.dart';

class TouristAttractionItemCard extends StatelessWidget {
  final String name;
  final String posterUrl;
  final String description;
  final Color cardColor;
  final String attribution;
  final String licence;
  const TouristAttractionItemCard(
      {Key key, this.name, this.posterUrl, this.description, this.cardColor = Colors.transparent, this.attribution, this.licence})
      : super(key: key);

  String get contributorName {
    if (attribution == null || attribution.isEmpty) return null;
    final startIndexContributor = attribution.indexOf('>') + 1;
    final endIndexContributor = attribution.indexOf('<', startIndexContributor);

    if (startIndexContributor == 0 || endIndexContributor == -1) {
      return null;
    }

    return attribution.substring(startIndexContributor, endIndexContributor);
  }

  String get contributionUrl {
    if (attribution == null || attribution.isEmpty) return null;
    final startIndexUrl = attribution.indexOf('https');
    final endIndexUrl = attribution.indexOf('"', startIndexUrl);
    if (startIndexUrl == -1 || endIndexUrl == -1) {
      return null;
    }

    return attribution.substring(startIndexUrl, endIndexUrl);
  }

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
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(name,
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(description ?? "",
                    style: TextStyle(
                      fontSize: 14,
                    )),
              ),
            ),
            if (attribution != null && attribution != "")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: getAttributionWidget(context, contributorName, contributionUrl, licence),
              ),
          ],
        ),
      ),
    );
  }
}
