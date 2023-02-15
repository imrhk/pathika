import 'package:flutter/material.dart';

import '../../../../extensions/context_extensions.dart';
import '../../widgets/attribution_widget.dart';

class TouristAttractionItemCard extends StatelessWidget {
  final String name;
  final String? posterUrl;
  final String? description;
  final String? attribution;
  final String? licence;
  const TouristAttractionItemCard({
    super.key,
    required this.name,
    this.posterUrl,
    this.description,
    this.attribution,
    this.licence,
  });

  String? get contributorName {
    if (attribution?.isEmpty ?? true) return null;
    final startIndexContributor = attribution!.indexOf('>') + 1;
    final endIndexContributor =
        attribution!.indexOf('<', startIndexContributor);

    if (startIndexContributor == 0 || endIndexContributor == -1) {
      return null;
    }

    return attribution!.substring(startIndexContributor, endIndexContributor);
  }

  String? get contributionUrl {
    if (attribution?.isEmpty ?? true) return null;
    final startIndexUrl = attribution!.indexOf('https');
    final endIndexUrl = attribution!.indexOf('"', startIndexUrl);
    if (startIndexUrl == -1 || endIndexUrl == -1) {
      return null;
    }

    return attribution!.substring(startIndexUrl, endIndexUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.brightness == Brightness.dark ||
              context.showColorsOnCards
          ? Colors.transparent
          : null,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: posterUrl != null,
              replacement: Container(
                height: 200,
              ),
              child: Container(
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
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(name,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(description ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                    )),
              ),
            ),
            if (attribution != "")
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: AttributionWidget(
                  photoBy: contributorName,
                  attributionUrl: contributionUrl,
                  licence: licence,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
