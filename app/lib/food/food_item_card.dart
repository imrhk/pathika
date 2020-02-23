import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Widget getAttributionWidget(
      BuildContext context, String photoBy, String atttributionUrl, String licence) {
    final startIndexUrl = licence.indexOf('http');
    final endIndexUrl = licence.indexOf('"', startIndexUrl);
    if (startIndexUrl == -1 || endIndexUrl == -1) {
      return Container();
    }
    final licenceUrl = licence.substring(startIndexUrl, endIndexUrl);

    final startIndexLicenceName = licence.indexOf('>') + 1;
    final endIndexLicenceName = licence.indexOf('<', startIndexLicenceName);
    if (startIndexLicenceName == 0 || endIndexLicenceName == -1) {
      return Container();
    }
    final licenceName =
        licence.substring(startIndexLicenceName, endIndexLicenceName);

    return Container(
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
          style: TextStyle(fontStyle: FontStyle.italic),
          children: [
            TextSpan(
              text: 'Photo',
              style: Theme.of(context).textTheme.caption.apply(
                    decoration: TextDecoration.underline,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(atttributionUrl);
                },
            ),
            TextSpan(
              text: ' by $photoBy',
              style: Theme.of(context).textTheme.caption,
            ),
            if (licence != null && licence != "")
              TextSpan(
                text: ' / ',
                style: Theme.of(context).textTheme.caption,
              ),
            TextSpan(
              text: '$licenceName',
              style: Theme.of(context).textTheme.caption.apply(
                    decoration: TextDecoration.underline,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(licenceUrl);
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
