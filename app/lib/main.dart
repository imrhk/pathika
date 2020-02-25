import 'package:flutter/material.dart';
import 'package:pathika/airport/airport_card.dart';
import 'package:pathika/app_drawer.dart';
import 'package:pathika/basic_info/basic_info_loader.dart';
import 'package:pathika/currency/currency_card.dart';
import 'package:pathika/dance/dance_card.dart';
import 'package:pathika/famous_people/person_list_card.dart';
import 'package:pathika/food/food_items_list_card.dart';
import 'package:pathika/industries/language_card.dart';
import 'package:pathika/location_map/location_map_card.dart';
import 'package:pathika/movies/movies_list_card.dart';
import 'package:pathika/sports/sports_card.dart';
import 'package:pathika/time/current_time_card.dart';
import 'package:pathika/time_to_visit/time_to_visit_card.dart';
import 'package:pathika/tourist_attractions/tourist_attractions_card.dart';

import 'climate/climate_card.dart';
import 'country/country_card.dart';
import 'language/language_card.dart';

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
      home: PlaceDetailsPage(placeId: 'buenos_aires'),
    );
  }
}

class PlaceDetailsPage extends StatefulWidget {
  final String placeId;
  const PlaceDetailsPage({Key key, @required this.placeId})
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

  changeAppTheme(
      {ThemeData appTheme, Color textColor, bool useColorsOnCard = false}) {
    setState(() {
      this.appTheme = appTheme;
      this.textColor = textColor;
      this.useColorsOnCard = useColorsOnCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mQuery = MediaQuery.of(context);
    final orientation = mQuery.orientation;
    final height = mQuery.size.height;
    return Theme(
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
        body: NestedScrollView(
          headerSliverBuilder: (ctx, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: height * 0.5,
                floating: false,
                pinned: true,
                flexibleSpace: BasicInfoLoader(
                  height: height,
                  orientation: orientation,
                ),
              ),
            ];
          },
          body: SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                SizedBox(height: 0),
                CountryCard(useColorsOnCard: useColorsOnCard),
                LanguageCard(useColorsOnCard: useColorsOnCard),
                CurrencyCard(useColorsOnCard: useColorsOnCard),
                CurrentTimeCard(
                  useColorsOnCard: useColorsOnCard,
                  timezoneOffsetInMinute: -180,
                ),
                ClimateCard(
                  useColorsOnCard: useColorsOnCard,
                ),
                TimeToVisitCard(useColorsOnCard: useColorsOnCard),
                TouristAttractionsCard(useColorsOnCard: useColorsOnCard),
                FoodItemsListCard(useColorsOnCard: useColorsOnCard),
                PersonListCard(useColorsOnCard: useColorsOnCard),
                MoviesListCard(useColorsOnCard: useColorsOnCard),
                DanceCard(useColorsOnCard: useColorsOnCard),
                SportsCard(useColorsOnCard: useColorsOnCard),
                IndustriesCard(useColorsOnCard: useColorsOnCard),
                AirportCard(useColorsOnCard: useColorsOnCard),
                LocationMapCard(useColorsOnCard: useColorsOnCard)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
