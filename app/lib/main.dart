import 'package:flutter/material.dart';
import 'package:pathika/app_drawer.dart';
import 'package:pathika/currency/currency_card.dart';
import 'package:pathika/detail_page_app_bar.dart';
import 'package:pathika/movie_item_card.dart';
import 'package:pathika/time/current_time_card.dart';
import 'package:pathika/time_to_visit/time_to_visit_card.dart';

import 'attraction_item_card.dart';
import 'climate/climate_card.dart';
import 'common/info_card.dart';
import 'country/country_card.dart';
import 'food_item_card.dart';
import 'language/language_card.dart';
import 'people_item_card.dart';

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
                CurrentTimeCard(useColorsOnCard: useColorsOnCard, timezoneOffsetInMinute: -180,),
                ClimateCard(useColorsOnCard: useColorsOnCard,),
                TimeToVisitCard(useColorsOnCard: useColorsOnCard),
                InfoCard(
                  color: useColorsOnCard ? Colors.green : null,
                  heading: 'Tourist Attractions',
                  body: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            AttractionItemCard(
                              name: 'Plaza de Mayo',
                              posterUrl:
                                  'https://lh3.googleusercontent.com/p/AF1QipNAR-22SdDBVKcr5YbgUo1N2M5J3mRSAlHd9v3p=s1600-w900',
                              description: 'Iconic 19th-century central square',
                              cardColor: Theme.of(context).brightness == Brightness.dark || useColorsOnCard ? Colors.transparent : null ,
                            ),
                            AttractionItemCard(
                              name: 'La Boca',
                              posterUrl:
                                  'https://lh3.googleusercontent.com/p/AF1QipOLUhLwscxdga2R6AP0HbufGXUgXLg3OUptoocB=s1600-w900',
                              description:
                                  'Caminito alley & La Bombonera stadium',
                              cardColor: Theme.of(context).brightness == Brightness.dark || useColorsOnCard ? Colors.transparent : null ,
                            ),
                            AttractionItemCard(
                              name: 'Obelisco',
                              posterUrl:
                                  'https://lh3.googleusercontent.com/p/AF1QipNjVDJsb7nwnkEYSs6n9vf3-coGoepNxJVOpvxE=s1600-w900',
                              description: 'Iconic 67m-high white obelisk',
                              cardColor: Theme.of(context).brightness == Brightness.dark || useColorsOnCard ? Colors.transparent : null ,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InfoCard(
                  color: useColorsOnCard ? Colors.teal : null,
                  heading: 'Food',
                  body: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 175,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            FoodItemCard(
                              label: 'Alfajores de Maicena',
                              url:
                                  'https://live.staticflickr.com/2592/3946003859_e4dddc50b4_n.jpg',
                              isVeg: true,
                            ),
                            FoodItemCard(
                              label: 'Dulce de leche',
                              url:
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Dulce_de_leche_2007.jpg/120px-Dulce_de_leche_2007.jpg',
                              isVeg: true,
                            ),
                            FoodItemCard(
                              label: 'Pizza',
                              url:
                                  'https://upload.wikimedia.org/wikipedia/commons/2/23/Pizza_Argentina_04.jpg',
                              isNonVeg: true,
                              isVeg: true,
                            ),
                            FoodItemCard(
                              label: 'Asado',
                              url:
                                  'https://upload.wikimedia.org/wikipedia/commons/3/3c/Parrillada_argentina.jpg',
                              isNonVeg: true,
                              isVeg: false,
                            ),
                            FoodItemCard(
                              label: 'Empanadillas de queso y cebolla',
                              url:
                                  'https://spoonacular.com/recipeImages/tuna-and-goat-cheese-empanadillas-2-89174.png',
                              isNonVeg: true,
                              isVeg: false,
                            ),
                            FoodItemCard(
                              label: 'Steak with Chimichurri Sauce',
                              url:
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Steak_with_Chimichurri_Sauce_%2813316528445%29.jpg/120px-Steak_with_Chimichurri_Sauce_%2813316528445%29.jpg',
                              isNonVeg: true,
                              isVeg: false,
                            ),
                          ],
                        ),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          Text('Show Veg Only'),
                          Switch(
                            value: showVeg,
                            onChanged: (value) {
                              setState(() {
                                showVeg = !showVeg;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InfoCard(
                  color: useColorsOnCard ? Colors.cyan : null,
                  heading: 'Famous People',
                  body: Column(
                    children: <Widget>[
                      PeopleItemCard(
                        name: 'Pope Fransis',
                        avatarUrl:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Pope_Francis_Korea_Haemi_Castle_19.jpg/362px-Pope_Francis_Korea_Haemi_Castle_19.jpg',
                      ),
                      Divider(),
                      PeopleItemCard(
                        name: 'Che Guevara',
                        avatarUrl:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/CheHigh.jpg/374px-CheHigh.jpg',
                        place: 'Rosario, 278 km from Buenos Aires',
                      ),
                      Divider(),
                      PeopleItemCard(
                        name: 'Lionel Messi',
                        avatarUrl:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Lionel_Messi_20180626.jpg/336px-Lionel_Messi_20180626.jpg',
                        work: 'Footballer',
                        place: 'Rosario',
                      ),
                      Divider(),
                      PeopleItemCard(
                        name: 'Diego Maradona ',
                        avatarUrl:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Diego_Maradona_2012_2.jpg/389px-Diego_Maradona_2012_2.jpg',
                        work: 'Footballer',
                      ),
                      Divider(),
                      PeopleItemCard(
                        name: 'Jorge Luis Borges',
                        avatarUrl:
                            'https://upload.wikimedia.org/wikipedia/commons/c/c6/Jorge_Luis_Borges.jpg',
                        work: 'Argentine short story writer',
                      ),
                    ],
                  ),
                ),
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
