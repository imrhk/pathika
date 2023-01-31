import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathika/basic_info/basic_info_app_bar.dart';
import 'package:pathika/theme/app_theme_bloc.dart';
import 'package:universal_io/io.dart' show HttpClient, Platform;

import 'common/attributions.dart';
import 'common/constants.dart';
import 'core/repository.dart';
import 'places/place_info.dart';

class PlacesListPage extends StatelessWidget {
  final HttpClient httpClient;
  final String currentLanguage;
  final void Function(String)? changePlace;

  const PlacesListPage({
    super.key,
    required this.httpClient,
    required this.currentLanguage,
    this.changePlace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      child: FutureBuilder<List<PlaceInfo>?>(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            List<PlaceInfo> places = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
      ),
    );
  }

  Widget getItemWidget(BuildContext context, PlaceInfo info) {
    onTap() {
      changePlace?.call(info.id);
      Navigator.of(context).pop();
    }

    Color? highlightTextColor = BlocProvider.of<AppThemeBloc>(context)
        .state
        .appThemeData
        .highlightTextColor;

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
                    color: highlightTextColor,
                    fontSize: 28.0,
                  ),
                ),
                if (info.country != null)
                  Text(
                    info.country!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: highlightTextColor,
                      fontSize: 18.0,
                    ),
                  ),
                getAttributionWidget(
                  context,
                  info.photoBy,
                  info.attributionUrl,
                  info.licence,
                  highlightTextColor,
                ),
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
        image: info.backgroundImage != null
            ? DecorationImage(
                image: NetworkImage(info.backgroundImage!),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
        child: Text(
          info.name,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: onTap,
        child: child,
      );
    } else {
      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      );
    }
  }

  Future<List<PlaceInfo>?> getPlaces() async {
    String? data = await Repository.getResponse(
      httpClient: httpClient,
      url: '$baseUrl/assets/json/$apiVersion/places_$currentLanguage.json',
    );
    if (data == null) {
      return null;
    }
    List<PlaceInfo> places = (json.decode(data) as List)
        .map<PlaceInfo?>((item) => PlaceInfo.fromMap(item))
        .where((element) => element != null)
        .map((e) => e!)
        .toList()
        .reversed
        .toList();
    return places;
  }
}
