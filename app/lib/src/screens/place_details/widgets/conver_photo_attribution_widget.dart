import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

import '../../../extensions/context_extensions.dart';
import '../../../models/place_models/place_models.dart';
import 'attribution_widget.dart';

class CoverPhotoAttributionWidget extends StatelessWidget {
  final PlaceInfo placeInfo;
  const CoverPhotoAttributionWidget({
    Key? key,
    required this.placeInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? text = Platform.isIOS
        ? placeInfo.place
        : '${context.l10n.cover_photo_location}: ${placeInfo.place}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (text != null)
          SizedBox(
            width: double.infinity,
            child: Text(
              text,
              textAlign: TextAlign.end,
            ),
          ),
        AttributionWidget(
          photoBy: placeInfo.photoBy,
          attributionUrl: placeInfo.attributionUrl,
          licence: placeInfo.licence,
        ),
        const SizedBox(height: 4),
        const Divider(
          thickness: 2,
        )
      ],
    );
  }
}
