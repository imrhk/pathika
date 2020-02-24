import 'package:flutter/material.dart';
import 'package:pathika/app_drawer.dart';
import 'package:pathika/currency/currency_card.dart';
import 'package:pathika/detail_page_app_bar.dart';
import 'package:pathika/famous_people/person_list_card.dart';
import 'package:pathika/food/food_items_list_card.dart';
import 'package:pathika/movie_item_card.dart';
import 'package:pathika/time/current_time_card.dart';
import 'package:pathika/time_to_visit/time_to_visit_card.dart';
import 'package:pathika/tourist_attractions/tourist_attractions_card.dart';

import 'climate/climate_card.dart';
import 'common/info_card.dart';
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
              DetailPageAppBar(
                backgroundImageUrl: 'assets/images/background.jpg',
                height: height,
                orientation: orientation,
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                CountryCard(
                  useColorsOnCard: useColorsOnCard,
                ),
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
                InfoCard(
                  color: useColorsOnCard ? Colors.indigo : null,
                  heading: 'Movies from Argentina',
                  body: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            MovieItemCard(
                              name: 'Relatos salvajes',
                              posterUrl:
                                  'https://image.tmdb.org/t/p/w300/aNlTNuLvm0mFbVvmayLvEq1qF84.jpg',
                            ),
                            MovieItemCard(
                              name: 'El secreto de sus ojos',
                              posterUrl:
                                  'https://image.tmdb.org/t/p/w300/j8tqe0Xk8fbi8RvU5Bb1x1cOmgo.jpg',
                            ),
                            MovieItemCard(
                              name: 'El Clan',
                              posterUrl:
                                  'https://image.tmdb.org/t/p/w300/t85v4agr03AdvuD2HcqhXKxV7II.jpg',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InfoCard(
                  color: useColorsOnCard ? Colors.red : null,
                  heading: 'Dance',
                  title: 'Tango',
                ),
                InfoCard(
                  color: useColorsOnCard ? Colors.lightBlue : null,
                  heading: 'Most Popular Sports',
                  title: '⚽ Soccer',
                ),
                InfoCard(
                  color: useColorsOnCard ? Colors.yellow : null,
                  heading: 'Industries',
                  title: 'Food Processing',
                  subtitle: '& Motor Vehicles, Consumer Durables, Textiles',
                ),
                InfoCard(
                  color: useColorsOnCard ? Colors.cyan : null,
                  heading: 'Airport ',
                  title: 'Ministro Pistarini International Airport',
                ),
                InfoCard(
                  color: useColorsOnCard ? Colors.lightBlue : null,
                  padding: EdgeInsets.all(0.0),
                  body: Image.network(
                    'https://maps.googleapis.com/maps/api/staticmap?center=0,0&zoom=1&size=515x300&maptype=terrain&markers=color:yellow%7Clabel:Aires%7C-34.6157437,-58.5733832&key=AIzaSyDGjnsYLLibMsr_Wg_A5MC7EK5dRSdXdtY',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
