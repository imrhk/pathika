import 'dart:convert';
import 'dart:io' show HttpClient;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pathika/common/attributions.dart';
import 'package:pathika/common/constants.dart';
import 'package:pathika/core/repository.dart';
import 'package:pathika/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'airport/airport_card.dart';
import 'app_drawer.dart';
import 'app_language/select_language_page.dart';
import 'basic_info/basic_info_app_bar.dart';
import 'climate/climate_card.dart';
import 'country/country_card.dart';
import 'currency/currency_card.dart';
import 'dance/dance_card.dart';
import 'famous_people/person_list_card.dart';
import 'food/food_items_list_card.dart';
import 'industries/language_card.dart';
import 'language/language_card.dart';
import 'location_map/location_map_card.dart';
import 'movies/movies_list_card.dart';
import 'place_details.dart';
import 'sports/sports_card.dart';
import 'time/current_time_card.dart';
import 'time_to_visit/time_to_visit_card.dart';
import 'tourist_attractions/tourist_attractions_card.dart';
import 'widgets/translate_list_item.dart';

void main() => runApp(PathikaApp2(
      httpClient: HttpClient(),
    ));

class PathikaApp2 extends StatefulWidget {
  final HttpClient httpClient;
  const PathikaApp2({Key key, this.httpClient}) : super(key: key);

  @override
  _PathikaApp2State createState() => _PathikaApp2State();
}

class _PathikaApp2State extends State<PathikaApp2> {

  AppTheme appTheme = AppTheme.Light();

  @override
  void initState() {
    super.initState();
    _loadUserTheme();
  }

  _loadUserTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey('APP_THEME')) {
      final appThemeValue = sharedPreferences.getString('APP_THEME');
      setState(() {
        appTheme = appThemeMap[appThemeValue]();      
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme.themeData ?? ThemeData(
          accentColor: Colors.white,
          primaryColor: Colors.black,
          textTheme: Theme.of(context).textTheme),
      // theme: ThemeData.dark(),
      home: InitPage(httpClient: widget.httpClient, appTheme: appTheme ?? AppTheme.Light(),),
    );
  }
}

class InitPage extends StatefulWidget {
  final HttpClient httpClient;
  final AppTheme appTheme;

  const InitPage({Key key, this.httpClient, this.appTheme}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  String _language;
  String _placeId;
  @override
  void initState() {
    super.initState();
    
    _getLanguage(context);
  }

  _getLanguage(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.containsKey(APP_LANGUAGE)) {
      String language = sharedPref.getString(APP_LANGUAGE);
      if (language != null && language.trim() != "") {
        _language = language;
        _getLatestPlace(context);
        return;
      }
    }
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => SelectLanguagePage(
              httpClient: widget.httpClient,
            )));
    _getLanguage(context);
  }

  _getLatestPlace(BuildContext context) async {
    try {
      String data = await Repository.getResponse(
        httpClient: widget.httpClient,
        url: '$BASE_URL/assets/json/$API_VERSION/places.json',
      );
      List<String> places =
          (json.decode(data) as List).map((e) => e.toString()).toList();
      if (places.length > 0) {
        setState(() {
          _placeId = places[places.length - 1];
        });
      }
    } catch (onError) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_placeId != null && _language != null) {
      return PlaceDetailsPage(
        placeId: _placeId,
        language: _language,
        httpClient: widget.httpClient,
        appTheme: widget.appTheme,
      );
    } else {
      return Scaffold(
        body: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}

class PlaceDetailsPage extends StatefulWidget {
  final String placeId;
  final String language;
  final HttpClient httpClient;
  final AppTheme appTheme;
  const PlaceDetailsPage(
      {Key key,
      @required this.placeId,
      this.language = "en",
      this.httpClient,
      this.appTheme})
      : assert(placeId != null),
        super(key: key);

  @override
  _PlaceDetailsPageState createState() => _PlaceDetailsPageState(
      appTheme: appTheme.themeData,
      textColor: appTheme.textColor,
      useColorsOnCard: appTheme.useColorsOnCard);
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  ThemeData appTheme;
  Color textColor;
  bool useColorsOnCard;
  bool isFirst = false;
  bool showVeg = true;

  String climateValue;

  double _previousOffset = -1;
  ScrollController _scrollController = ScrollController();
  ScrollDirection _verticalScrollDirection = ScrollDirection.idle;

  _PlaceDetailsPageState(
      {this.appTheme, this.textColor, this.useColorsOnCard = false});

  @override
  void dispose() {
    _scrollController.dispose();
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
  }

  changeAppTheme(AppTheme appTheme) async {
    Navigator.pop(context);
    setState(() {
      this.appTheme = appTheme.themeData;
      this.textColor = appTheme.textColor;
      this.useColorsOnCard = appTheme.useColorsOnCard;
    });

    SharedPreferences.getInstance().then(
        (sharedPref) => sharedPref.setString('APP_THEME', appTheme.label));
    //todo save theme
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
      child: Theme(
        key: ValueKey<String>("$useColorsOnCard$textColor$appTheme"),
        data: textColor == null
            ? appTheme
            : appTheme.copyWith(
                textTheme: appTheme.textTheme
                    .apply(bodyColor: textColor, displayColor: textColor),
              ),
        child: Scaffold(
          drawer: AppDrawer(
            changeAppTheme: changeAppTheme,
          ),
          body: FutureBuilder<PlaceDetails>(
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error occured.\n ${snapshot.error.toString()}'),
                );
              } else {
                return mapPlaceDetailsDataToUI(context, snapshot.data);
              }
            },
            initialData: PlaceDetails.empty(),
            future: _getData(context),
          ),
        ),
      ),
    );
  }

  Widget mapPlaceDetailsDataToUI(
      BuildContext context, PlaceDetails placeDetails) {
    final mQuery = MediaQuery.of(context);
    final orientation = mQuery.orientation;
    final height = mQuery.size.height;

    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: height * 0.5,
          floating: false,
          pinned: true,
          flexibleSpace: BasicInfoAppBar(
            height: height,
            orientation: orientation,
            basicInfo: placeDetails.basicInfo,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
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
                  timezoneOffsetInMinute: placeDetails.timezoneOffsetInMinutes),
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
            ]
                .map((widget) => TranslateListItem(
                    traslateHeight: 600,
                    child: widget,
                    duration: Duration(seconds: 1),
                    axis: Axis.vertical,
                    getScrollDirection: getVerticalScrollDirection))
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
                Container(
                  width: double.infinity,
                  child: Text(
                    'Cover photo location: ${placeDetails.basicInfo.place}',
                    textAlign: TextAlign.end,
                  ),
                ),
                getAttributionWidget(
                    context,
                    placeDetails.basicInfo.photoBy,
                    placeDetails.basicInfo.attributionUrl,
                    placeDetails.basicInfo.licence),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
          ),
        )
      ],
    );
  }

  Future<PlaceDetails> _getData(BuildContext context) async {
    return Repository.getResponse(
      httpClient: widget.httpClient,
      url:
          '$BASE_URL/assets/json/$API_VERSION/${widget.placeId}/details_${widget.language}.json',
      cacheTime: Duration(days: 7),
    ).then((source) => Future.value(PlaceDetails.fromJson(source)));
  }
}
