import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TouristAttractionItemCard extends StatelessWidget {
  final String name;
  final String posterUrl;
  final String description;
  final Color cardColor;
  final String attribution;
  const TouristAttractionItemCard(
      {Key key,
      this.name,
      this.posterUrl,
      this.description,
      this.cardColor = Colors.transparent,
      this.attribution})
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
        width: 350,
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
            if (attribution != null && attribution != "")
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: getAttributionWidget(context, attribution)),
          ],
        ),
      ),
    );
  }

  Widget getAttributionWidget(BuildContext context, String attribution) {
//                    "<a href=\"https://maps.google.com/maps/contrib/115635279769083588516\">André Magdalena</a>"

    final startIndexUrl = attribution.indexOf('https');
    final endIndexUrl = attribution.indexOf('"', startIndexUrl);
    if(startIndexUrl == -1 || endIndexUrl == -1)  {
      return Container();
    }

    final url = attribution.substring(startIndexUrl, endIndexUrl);
    final startIndexContributor = attribution.indexOf('>') + 1;
    final endIndexContributor = attribution.indexOf('<', startIndexContributor);

    if(startIndexContributor == 0 || endIndexContributor == -1) {
      return Container();
    }
    
    final contributorName =
        attribution.substring(startIndexContributor, endIndexContributor);
    return Container(
      width: double.infinity,
      child: new RichText(
        textAlign: TextAlign.end,
        text: new TextSpan(
          style: TextStyle(fontStyle: FontStyle.italic),
          children: [
            new TextSpan(
              text: 'Photo by ',
              style: Theme.of(context).textTheme.caption,
            ),
            new TextSpan(
              text: contributorName,
              style: Theme.of(context).textTheme.caption.apply(
                    decoration: TextDecoration.underline,
                  ),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(url);
                },
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
