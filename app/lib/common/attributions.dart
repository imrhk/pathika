import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathika/localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';

bool isNullOrEmpty(String str) {
  return str == null || str.isEmpty;
}

Widget getAttributionWidget(BuildContext context, String photoBy, String atttributionUrl, String licence, [Color textColor]) {
  if (textColor == null) {
    textColor = Theme.of(context).textTheme.caption.color;
  }

  if (isNullOrEmpty(photoBy) && isNullOrEmpty(atttributionUrl) && isNullOrEmpty(licence)) {
    return Container();
  }

  getLicenceUrl() {
    if (licence == null || licence.isEmpty) return null;
    final startIndexUrl = licence.indexOf('http');
    final endIndexUrl = licence.indexOf('"', startIndexUrl);
    if (startIndexUrl == -1 || endIndexUrl == -1) {
      return null;
    }
    return licence.substring(startIndexUrl, endIndexUrl);
  }

  getLicenceLabel() {
    if (licence == null || licence.isEmpty) return null;
    final startIndexLicenceName = licence.indexOf('>') + 1;
    final endIndexLicenceName = licence.indexOf('<', startIndexLicenceName);
    if (startIndexLicenceName == 0 || endIndexLicenceName == -1) {
      return null;
    }
    return licence.substring(startIndexLicenceName, endIndexLicenceName);
  }

  return Container(
    width: double.infinity,
    child: RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.end,
      text: TextSpan(
        style: TextStyle(fontStyle: FontStyle.italic),
        children: [
          if (photoBy != null)
            TextSpan(
              text: BlocProvider.of<LocalizationBloc>(context).localize('_photo_by', 'Photo by'),
              style: Theme.of(context).textTheme.caption.apply(
                    decoration: TextDecoration.underline,
                    color: textColor,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(atttributionUrl);
                },
            ),
          if (photoBy != null)
            TextSpan(
              text: ' $photoBy',
              style: Theme.of(context).textTheme.caption.apply(
                    color: textColor,
                  ),
            ),
          if (licence != null && licence != "")
            TextSpan(
              text: ' / ',
              style: Theme.of(context).textTheme.caption.apply(
                    color: textColor,
                  ),
            ),
          if (licence != null && licence != "")
            TextSpan(
              text: getLicenceLabel(),
              style: Theme.of(context).textTheme.caption.apply(
                    decoration: TextDecoration.underline,
                    color: textColor,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(getLicenceUrl());
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
