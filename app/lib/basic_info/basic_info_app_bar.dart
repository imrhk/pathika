import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pathika/common/info_card.dart';
import 'package:pathika/places/place_details_page.dart';
import 'package:universal_io/io.dart' show Platform;

import 'basic_info.dart';

class BasicInfoAppBar extends StatelessWidget {
  final double height;
  final Orientation orientation;
  final BasicInfo basicInfo;
  const BasicInfoAppBar({
    Key key,
    this.height,
    this.orientation,
    this.basicInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return InfoCard(
        padding: EdgeInsets.all(0.0),
        body: Container(
          width: double.infinity,
          height: height,
          child: Stack(
            children: <Widget>[
              CardBackgroundWidget(
                url: basicInfo.backgroundImage,
                boxFit: orientation == Orientation.portrait ? BoxFit.fitHeight : BoxFit.fitWidth,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getCoverPhotoAttribution(context, basicInfo, Colors.white),
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
        boxFit: orientation == Orientation.portrait ? BoxFit.fitHeight : BoxFit.fitWidth,
      ),
    );
  }

  Widget _getTitle() {
    return Container(
      child: Text(
        basicInfo.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class CardBackgroundWidget extends StatelessWidget {
  final String url;
  final BoxFit boxFit;
  const CardBackgroundWidget({Key key, this.url, this.boxFit = BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(url),
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
                colors: [Colors.black.withOpacity(0.9), Colors.black.withOpacity(0.0)],
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
