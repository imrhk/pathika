import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathika/basic_info/basic_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart' show HttpClient, Platform;
import 'package:url_launcher/url_launcher.dart';

import '../ads/ad_config.dart';
import '../airport/airport_card.dart';
import '../app_drawer.dart';
import '../basic_info/basic_info_app_bar.dart';
import '../climate/climate_card.dart';
import '../common/attributions.dart';
import '../common/constants.dart';
import '../core/adt_details.dart';
import '../core/repository.dart';
import '../country/country_card.dart';
import '../currency/currency_card.dart';
import '../dance/dance_card.dart';
import '../famous_people/person_list_card.dart';
import '../food/food_items_list_card.dart';
import '../industries/industry_card.dart';
import '../language/language_card.dart';
import '../localization/localization.dart';
import '../location_map/location_map_card.dart';
import '../movies/movies_list_card.dart';
import '../places_list_page.dart';
import '../sports/sports_card.dart';
import '../theme/app_theme.dart';
import '../time/current_time_card.dart';
import '../time_to_visit/time_to_visit_card.dart';
import '../tourist_attractions/tourist_attractions_card.dart';
import '../trivia/trivia_card.dart';
import '../widgets/translate_list_item.dart';
import 'place_details.dart';

class PlaceDetailsPage extends StatefulWidget {
  final String placeId;
  final String language;
  final HttpClient httpClient;
  final AppTheme appTheme;
  final Function appLanguageChanged;
  final Function changePlace;
  const PlaceDetailsPage({
    Key key,
    this.placeId,
    this.language = "en",
    this.httpClient,
    this.appTheme,
    this.appLanguageChanged,
    this.changePlace,
  }) : super(key: key);

  @override
  _PlaceDetailsPageState createState() {
    assert(placeId != null);
    return _PlaceDetailsPageState(
        materialAppTheme: appTheme.themeDataMaterial,
        cupertinoThemeData: appTheme.themeDataCupertino,
        textColor: appTheme.textColor,
        useColorsOnCard: appTheme.useColorsOnCard);
  }
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  ThemeData materialAppTheme;
  CupertinoThemeData cupertinoThemeData;
  Color textColor;
  bool useColorsOnCard;
  bool isFirst = false;
  bool showVeg = true;

  String climateValue;

  double _previousOffset = -1;
  ScrollController _scrollController = ScrollController();
  ScrollDirection _verticalScrollDirection = ScrollDirection.idle;

  final adConfig = getAdConfig();
  BannerAd bottomBarPromoAd;
  _PlaceDetailsPageState({this.materialAppTheme, this.cupertinoThemeData, this.textColor, this.useColorsOnCard = false}) {
    bottomBarPromoAd = adConfig == null
        ? null
        : BannerAd(
            adUnitId: getAdConfig().adsId[PLACES_BOTTOM_BAR_PROMO],
            size: AdSize.banner,
            targetingInfo: targetingInfo,
            listener: (MobileAdEvent event) {
              print("BannerAd event is $event");
            },
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bottomBarPromoAd?.dispose();
    super.dispose();
  }

  ScrollDirection getVerticalScrollDirection() {
    return _verticalScrollDirection;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double currentOffset = _scrollController.offset;
      if (currentOffset > _previousOffset) {
        _verticalScrollDirection = ScrollDirection.forward;
      } else if (currentOffset < _previousOffset) {
        _verticalScrollDirection = ScrollDirection.reverse;
      } else {
        _verticalScrollDirection = ScrollDirection.idle;
      }
      _previousOffset = currentOffset;
    });
    if (bottomBarPromoAd != null) {
      bottomBarPromoAd
        ..load()
        ..show();
    }
  }

  changeAppTheme(AppTheme appTheme) async {
    Navigator.pop(context);
    setState(() {
      this.materialAppTheme = appTheme.themeDataMaterial;
      this.cupertinoThemeData = appTheme.themeDataCupertino;
      this.textColor = appTheme.textColor;
      this.useColorsOnCard = appTheme.useColorsOnCard;
    });

    SharedPreferences.getInstance().then((sharedPref) => sharedPref.setString('APP_THEME', appTheme.label));
    //todo save theme
  }

  Widget _getThemeWidget() {
    return Theme(
      key: ValueKey<String>("$useColorsOnCard$textColor$materialAppTheme"),
      data: textColor == null
          ? materialAppTheme
          : materialAppTheme.copyWith(
              textTheme: materialAppTheme.textTheme.apply(bodyColor: textColor, displayColor: textColor),
            ),
      child: AppScaffold(
        child: getPlacesDetailsWidget(),
        getAppDrawer: _buildMaterialAppDrawer,
      ),
    );
  }

  Widget _buildMaterialAppDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: AppSettings(
          httpClient: widget.httpClient,
          appLanguageChanged: widget.appLanguageChanged,
          changeAppTheme: changeAppTheme,
          currentLanguge: widget.language,
          changePlace: widget.changePlace,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _previousOffset = 0;
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 1000,
      ),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(child: child, opacity: animation);
      },
      child: _getThemeWidget(),
    );
  }

  Widget getPlacesDetailsWidget() {
    return FutureBuilder<PlaceDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${BlocProvider.of<LocalizationBloc>(context).localize('error_occured', 'Error occured')}\n ${snapshot.error.toString()}'),
          );
        } else {
          return mapPlaceDetailsDataToUI(context, snapshot.data);
        }
      },
      initialData: PlaceDetails.empty(),
      future: _getData(context),
    );
  }

  Widget getCupertinoAppBar(PlaceDetails placeDetails) {
    return CupertinoTheme(
      data: cupertinoThemeData,
      child: CupertinoSliverNavigationBar(
        automaticallyImplyLeading: false,
        largeTitle: Text(placeDetails.basicInfo.name),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(IconData(0xf453, fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons'), color: CupertinoColors.activeBlue),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CupertinoTheme(
                      data: cupertinoThemeData,
                      child: CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(
                          middle: GestureDetector(
                            child: Text(
                              BlocProvider.of<LocalizationBloc>(context).localize('_discover', 'Discover'),
                            ),
                          ),
                          leading: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Icon(CupertinoIcons.left_chevron, color: CupertinoColors.activeBlue),
                                Flexible(
                                  child: Text(
                                    placeDetails.basicInfo.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: CupertinoColors.activeBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ),
                        child: PlacesListPage(
                          httpClient: widget.httpClient,
                          changePlace: widget.changePlace,
                          currentLanguage: widget.language,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 10),
            GestureDetector(
              child: Icon(CupertinoIcons.settings, color: CupertinoColors.activeBlue),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CupertinoTheme(
                      data: cupertinoThemeData,
                      child: CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(
                          middle: GestureDetector(
                            child: Text(
                              BlocProvider.of<LocalizationBloc>(context).localize('_settings', 'Settings'),
                            ),
                          ),
                          leading: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Icon(CupertinoIcons.left_chevron, color: CupertinoColors.activeBlue),
                                Flexible(
                                  child: Text(
                                    placeDetails.basicInfo.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: CupertinoColors.activeBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ),
                        child: AppSettings(
                          httpClient: widget.httpClient,
                          appLanguageChanged: widget.appLanguageChanged,
                          changeAppTheme: changeAppTheme,
                          currentLanguge: widget.language,
                          changePlace: widget.changePlace,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getMaterialAppBar(PlaceDetails placeDetails) {
    final mQuery = MediaQuery.of(context);
    final height = mQuery.size.height;
    return SliverAppBar(
      expandedHeight: height * 0.5,
      floating: false,
      pinned: true,
      flexibleSpace: getBasicInfoWidget(placeDetails),
      actions: <Widget>[
        GestureDetector(
          child: Icon(Icons.search),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Theme(
                  data: materialAppTheme,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        BlocProvider.of<LocalizationBloc>(context).localize('_discover', 'Discover'),
                      ),
                    ),
                    body: PlacesListPage(
                      httpClient: widget.httpClient,
                      changePlace: widget.changePlace,
                      currentLanguage: widget.language,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget getBasicInfoWidget(PlaceDetails placeDetails) {
    final mQuery = MediaQuery.of(context);
    final orientation = mQuery.orientation;
    final height = mQuery.size.height;

    return BasicInfoAppBar(
      height: height * 0.5,
      orientation: orientation,
      basicInfo: placeDetails.basicInfo,
    );
  }

  Widget getSliverAppBar(PlaceDetails placeDetails) {
    if (Platform.isIOS) {
      return getCupertinoAppBar(placeDetails);
    } else {
      return getMaterialAppBar(placeDetails);
    }
  }

  Widget mapPlaceDetailsDataToUI(BuildContext context, PlaceDetails placeDetails) {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        getSliverAppBar(placeDetails),
        if (Platform.isIOS)
          SliverToBoxAdapter(
            child: getBasicInfoWidget(placeDetails),
          ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            (<Widget>[
              CountryCard(
                details: placeDetails.countryDetails,
                useColorsOnCard: useColorsOnCard,
              ),
              LanguageCard(
                details: placeDetails.languageDetails,
                useColorsOnCard: useColorsOnCard,
              ),
              CurrencyCard(
                details: placeDetails.currencyDetails,
                useColorsOnCard: useColorsOnCard,
                httpclient: widget.httpClient,
              ),
              CurrentTimeCard(
                useColorsOnCard: useColorsOnCard,
                timezoneOffsetInMinute: placeDetails.timezoneOffsetInMinutes,
              ),
              ClimateCard(
                details: placeDetails.climateDetails,
                useColorsOnCard: useColorsOnCard,
              ),
              TimeToVisitCard(
                details: placeDetails.timeToVisitDetails,
                useColorsOnCard: useColorsOnCard,
              ),
              TouristAttractionsCard(
                details: placeDetails.touristPlacesList,
                useColorsOnCard: useColorsOnCard,
              ),
              FoodItemsListCard(
                details: placeDetails.foodItemsList,
                useColorsOnCard: useColorsOnCard,
              ),
              PersonListCard(
                details: placeDetails.personsList,
                useColorsOnCard: useColorsOnCard,
              ),
              MoviesListCard(
                details: placeDetails.moviesList,
                useColorsOnCard: useColorsOnCard,
                countryName: placeDetails.countryDetails.name,
              ),
              DanceCard(
                details: placeDetails.danceDetails,
                useColorsOnCard: useColorsOnCard,
              ),
              SportsCard(
                details: placeDetails.sportsDetails,
                useColorsOnCard: useColorsOnCard,
              ),
              IndustriesCard(
                details: placeDetails.industriesDetails,
                useColorsOnCard: useColorsOnCard,
              ),
              AirportCard(
                details: placeDetails.airport,
                useColorsOnCard: useColorsOnCard,
              ),
              LocationMapCard(
                details: placeDetails.locationMapList,
                useColorsOnCard: useColorsOnCard,
              ),
              TriviaListCard(
                details: placeDetails.triviaListDetails,
                useColorsOnCard: useColorsOnCard,
              ),
            ]..removeWhere((element) => element is Details && (element as Details).details == null))
                .map((widget) => Platform.isIOS
                    ? widget
                    : TranslateListItem(
                        traslateHeight: 600,
                        child: widget,
                        duration: Duration(seconds: 1),
                        axis: Axis.vertical,
                        getScrollDirection: getVerticalScrollDirection))
                // .map(
                //   (widget) => Theme(
                //     data: materialAppTheme,
                //     child: widget,
                //   ),
                // )
                .toList(),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              bottom: 4,
              right: 10,
              left: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 4),
                Divider(
                  thickness: 2,
                ),
                if (!Platform.isIOS) getCoverPhotoAttribution(context, placeDetails.basicInfo, Theme.of(context).textTheme.caption.color),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontStyle: FontStyle.italic),
                    children: [
                      if (!kIsWeb) //web not working for widget span
                        WidgetSpan(
                          child: Icon(Icons.info_outline, size: 14, color: Theme.of(context).textTheme.caption.color),
                        ),
                      TextSpan(
                        text: BlocProvider.of<LocalizationBloc>(context).localize(
                            'report_issue', ' If you believe there is translation issue or any other issue with the content, please report '),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      TextSpan(
                        text: ' ${BlocProvider.of<LocalizationBloc>(context).localize('_here', ' here')} ',
                        style: Theme.of(context).textTheme.caption.apply(
                              decoration: TextDecoration.underline,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openForm();
                          },
                      ),
                      if (!kIsWeb)
                        WidgetSpan(
                          child: GestureDetector(
                            child: Icon(
                              Icons.open_in_new,
                              size: 14,
                              color: Theme.of(context).textTheme.caption.color,
                            ),
                            onTap: _openForm,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    BlocProvider.of<LocalizationBloc>(context).localize('made_in_india', 'Made with ❤️ in India'),
                    style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.subtitle1.color),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _openForm() async {
    launch('https://forms.gle/bb3LZhreSfeHHy1f6');
  }

  Future<PlaceDetails> _getData(BuildContext context) async {
    getResponse(String language) {
      return Repository.getResponse(
          httpClient: widget.httpClient,
          url: '$BASE_URL/assets/json/$API_VERSION/${widget.placeId}/details_$language.json',
          cacheTime: Duration(days: 7));
    }

    String response = await getResponse(widget.language);
    if (response == null) {
      response = await getResponse('en');
    }
    return Future.value(PlaceDetails.fromJson(response));
  }
}

Widget getCoverPhotoAttribution(BuildContext context, BasicInfo basicInfo, Color textColor) {
  final text = Platform.isIOS
      ? basicInfo.place
      : '${BlocProvider.of<LocalizationBloc>(context).localize('cover_photo_location', 'Cover photo location')}: ${basicInfo.place}';

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: double.infinity,
        child: Text(
          text,
          textAlign: TextAlign.end,
          style: TextStyle(color: textColor),
        ),
      ),
      getAttributionWidget(context, basicInfo.photoBy, basicInfo.attributionUrl, basicInfo.licence, textColor),
      SizedBox(height: 4),
      Divider(
        thickness: 2,
      )
    ],
  );
}

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Function getAppBar;
  final Function getAppDrawer;
  final Function getNavigationbar;

  const AppScaffold({
    Key key,
    this.child,
    this.getAppDrawer,
    this.getAppBar,
    this.getNavigationbar,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: child,
        navigationBar: getNavigationbar?.call(),
      );
    } else {
      return Scaffold(
        body: child,
        appBar: getAppBar?.call(),
        drawer: getAppDrawer?.call(context),
      );
    }
  }
}
