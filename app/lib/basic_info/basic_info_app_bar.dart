import 'package:flutter/material.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

import '../common/constants.dart';
import '../extensions/context_extensions.dart';
import '../models/place_models.dart';
import '../widgets/conver_photo_attribution_widget.dart';
import '../widgets/info_card.dart';
import '../widgets/optional_shimmer.dart';

class BasicInfoAppBar extends StatelessWidget with PlatformWidgetMixin {
  final double? height;
  final Orientation? orientation;
  final PlaceInfo placeInfo;
  const BasicInfoAppBar({
    super.key,
    this.height,
    this.orientation,
    required this.placeInfo,
  });

  @override
  Widget buildAndroid(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      title: _getTitle(context),
      background: CardBackgroundWidget(
        url: placeInfo.backgroundImage,
        boxFit: orientation == Orientation.portrait
            ? BoxFit.fitHeight
            : BoxFit.fitWidth,
      ),
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return InfoCard(
      padding: const EdgeInsets.all(0.0),
      color: materialTransparent,
      body: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          children: <Widget>[
            CardBackgroundWidget(
              url: placeInfo.backgroundImage,
              boxFit: orientation == Orientation.portrait
                  ? BoxFit.fitHeight
                  : BoxFit.fitWidth,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CoverPhotoAttributionWidget(placeInfo: placeInfo),
              ),
            ),
          ],
        ),
      ),
      isAudiable: false,
    );
  }

  Widget _getTitle(BuildContext context) {
    final style = context.textGradient != null
        ? context.theme.textTheme.headlineSmall
        : null;
    return OptionalShimmer(
      child: Text(
        placeInfo.name,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }
}

class CardBackgroundWidget extends StatelessWidget {
  final String? url;
  final BoxFit boxFit;
  const CardBackgroundWidget({super.key, this.url, this.boxFit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (url != null)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(url!),
                fit: boxFit,
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.0)
                ],
                end: FractionalOffset.topCenter,
                begin: FractionalOffset.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
