import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pathika/basic_info/basic_info.dart';
import 'package:pathika/basic_info/basic_info_app_bar.dart';
import 'package:pathika/places/place_details_page.dart';
import 'package:universal_io/io.dart';

import 'common/attributions.dart';
import 'common/constants.dart';
import 'core/repository.dart';
import 'places/place_info.dart';

class PlacesListPage extends StatelessWidget {
  final HttpClient httpClient;
  final String currentLanguage;
  final Function changePlace;

  const PlacesListPage({
    Key key,
    this.httpClient,
    this.currentLanguage,
    this.changePlace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaceInfo>>(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          List<PlaceInfo> places = snapshot.data;
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (ctx, index) {
                final item = places[index];
                return getItemWidget(
                  context,
                  item,
                );
              },
              itemCount: places.length,
              );
        }
        return Container();
      },
      future: getPlaces(),
    );
  }

  Widget getItemWidget(BuildContext context, PlaceInfo info) {
    Function onTap = () {
      changePlace(info.id);
      Navigator.of(context).pop();
    };

    Widget child = Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: CardBackgroundWidget(
            url: info.backgroundImage,
            boxFit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  info.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                  ),
                ),
                Text(
                  info.country,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                getAttributionWidget(context, info.photoBy, info.attributionUrl, info.licence, Colors.white),
              ],
            ),
          ),
        ),
      ],
    );

    Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(info.backgroundImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
        child: Text(
          info.name,
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
    if (Platform.isIOS) {
      return CupertinoButton(
        child: child,
        onPressed: onTap,
      );
    } else {
      return Card(
        elevation: 5,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      );
    }
  }

  Future<List<PlaceInfo>> getPlaces() async {
    String data = await Repository.getResponse(
      httpClient: httpClient,
      url: '$BASE_URL/assets/json/$API_VERSION/places_$currentLanguage.json',
    );
    List<PlaceInfo> places = (json.decode(data) as List).map<PlaceInfo>((item) => PlaceInfo.fromMap(item)).toList().reversed.toList();
    return places;
  }
}
