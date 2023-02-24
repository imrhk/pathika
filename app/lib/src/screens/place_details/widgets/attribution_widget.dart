import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../extensions/context_extensions.dart';
import '../../../utils/utils.dart';

class AttributionWidget extends StatelessWidget {
  final String? photoBy;
  final String? attributionUrl;
  final String? licence;

  const AttributionWidget({
    super.key,
    this.photoBy,
    this.attributionUrl,
    this.licence,
  });

  String? get _licenceUrl {
    final licence = this.licence;
    if (licence == null || licence.isEmpty) return null;
    final startIndexUrl = licence.indexOf('http');
    final endIndexUrl = licence.indexOf('"', startIndexUrl);
    if (startIndexUrl == -1 || endIndexUrl == -1) {
      return null;
    }
    return licence.substring(startIndexUrl, endIndexUrl);
  }

  String? get _licenceLabel {
    final licence = this.licence;
    if (licence == null || licence.isEmpty) return null;
    final startIndexLicenceName = licence.indexOf('>') + 1;
    final endIndexLicenceName = licence.indexOf('<', startIndexLicenceName);
    if (startIndexLicenceName == 0 || endIndexLicenceName == -1) {
      return null;
    }
    return licence.substring(startIndexLicenceName, endIndexLicenceName);
  }

  @override
  Widget build(BuildContext context) {
    if (isNullOrEmpty(photoBy) &&
        isNullOrEmpty(attributionUrl) &&
        isNullOrEmpty(licence)) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        text: TextSpan(
          style: const TextStyle(fontStyle: FontStyle.italic),
          children: [
            if (photoBy != null)
              TextSpan(
                text: context.l10n.photo_by,
                style: context.theme.textTheme.bodySmall?.apply(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchURL(attributionUrl);
                  },
              ),
            if (photoBy != null)
              TextSpan(
                  text: ' $photoBy', style: context.theme.textTheme.bodySmall),
            if (licence != "")
              TextSpan(text: ' / ', style: context.theme.textTheme.bodySmall),
            if (licence != "")
              TextSpan(
                text: _licenceLabel,
                style: context.theme.textTheme.bodySmall?.apply(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchURL(_licenceUrl);
                  },
              ),
          ],
        ),
      ),
    );
  }

  _launchURL(String? url) async {
    final uri = Uri.tryParse(url ?? '');
    if (uri == null) {
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
