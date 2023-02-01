import 'dart:io';

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' show Platform;

import '../common/info_card.dart';
import '../core/utility.dart';
import '../places/place_details_page.dart';
import 'basic_info.dart';

class BasicInfoAppBar extends StatelessWidget {
  final double? height;
  final Orientation? orientation;
  final BasicInfo basicInfo;
  const BasicInfoAppBar({
    super.key,
    this.height,
    this.orientation,
    required this.basicInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return InfoCard(
        padding: const EdgeInsets.all(0.0),
        color: materialTransparent,
        body: SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            children: <Widget>[
              CardBackgroundWidget(
                url: basicInfo.backgroundImage,
                boxFit: orientation == Orientation.portrait
                    ? BoxFit.fitHeight
                    : BoxFit.fitWidth,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getCoverPhotoAttribution(context, basicInfo),
                ),
              ),
            ],
          ),
        ),
        isAudiable: false,
      );
    }
    return FlexibleSpaceBar(
      centerTitle: true,
      title: _getTitle(),
      background: CardBackgroundWidget(
        url: basicInfo.backgroundImage,
        boxFit: orientation == Orientation.portrait
            ? BoxFit.fitHeight
            : BoxFit.fitWidth,
      ),
    );
  }

  Widget _getTitle() {
    return Text(
      basicInfo.name,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
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
