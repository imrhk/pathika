import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget getAttributionWidget(BuildContext context, String photoBy,
    String atttributionUrl, String licence) {
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
