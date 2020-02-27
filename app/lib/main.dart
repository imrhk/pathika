import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pathika/common/attributions.dart';
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

void main() => runApp(PathikaApp2());

class PathikaApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Colors.white,
          primaryColor: Colors.black,
          textTheme: Theme.of(context).textTheme),
      // theme: ThemeData.dark(),
      home: InitPage(),
    );
  }
}

class InitPage extends StatefulWidget {
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
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => SelectLanguagePage()));
    _getLanguage(context);
  }

  _getLatestPlace(BuildContext context) async {
    try {
      String data = await DefaultAssetBundle.of(context)
          .loadString("assets/data/places.json");
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
  const PlaceDetailsPage(
      {Key key, @required this.placeId, this.language = "en"})
      : assert(placeId != null),
        super(key: key);

  @override
  _PlaceDetailsPageState createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  ThemeData appTheme = ThemeData.light()
      .copyWith(primaryColor: Colors.black, accentColor: Colors.lightBlue);
  Color textColor;
  bool useColorsOnCard = false;
  bool isFirst = false;
  bool showVeg = true;

  String climateValue;

  double _previousOffset = -1;
  ScrollController _scrollController = ScrollController();
  ScrollDirection _verticalScrollDirection = ScrollDirection.idle;

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

  changeAppTheme({
    ThemeData appTheme,
    Color textColor,
    bool useColorsOnCard = false,
  }) {
    Navigator.pop(context);
    setState(() {
      this.appTheme = appTheme;
      this.textColor = textColor;
      this.useColorsOnCard = useColorsOnCard;
    });
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
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              bottom: 4,
              right: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Text(
                    'Above photo is from: ${placeDetails.basicInfo.place}',
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
      ],
    );
  }

  Future<PlaceDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/details.json")
        .then((source) => Future.value(PlaceDetails.fromJson(source)));
  }
}
