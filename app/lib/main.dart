import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart' show HttpClient;
import 'package:url_launcher/url_launcher.dart';

import 'airport/airport_card.dart';
import 'app_drawer.dart';
import 'app_language/select_language_page.dart';
import 'basic_info/basic_info_app_bar.dart';
import 'climate/climate_card.dart';
import 'common/attributions.dart';
import 'common/constants.dart';
import 'core/flutter_assets_client.dart';
import 'core/repository.dart';
import 'country/country_card.dart';
import 'currency/currency_card.dart';
import 'dance/dance_card.dart';
import 'famous_people/person_list_card.dart';
import 'food/food_items_list_card.dart';
import 'industries/language_card.dart';
import 'language/language_card.dart';
import 'localization/localization.dart';
import 'localization/localization_bloc.dart';
import 'localization/localization_event.dart';
import 'location_map/location_map_card.dart';
import 'movies/movies_list_card.dart';
import 'place_details.dart';
import 'sports/sports_card.dart';
import 'theme/app_theme.dart';
import 'time/current_time_card.dart';
import 'time_to_visit/time_to_visit_card.dart';
import 'tourist_attractions/tourist_attractions_card.dart';
import 'trivia/trivia_card.dart';
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
    if (sharedPreferences.containsKey('APP_THEME')) {
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
      theme: appTheme.themeData ??
          ThemeData(
              accentColor: Colors.white,
              primaryColor: Colors.black,
              textTheme: Theme.of(context).textTheme),
      // theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => LocalizationBloc(
          httpClient: widget.httpClient,
          assetsClient: FlutterAssetsClient(
            assetBundle: DefaultAssetBundle.of(context),
          ),
        )..add(
            FetchLocalization(LOCALE_DEFAULT),
          ),
        child: InitPage(
          httpClient: widget.httpClient,
          appTheme: appTheme ?? AppTheme.Light(),
        ),
      ),
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
  bool _isRtl;
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
      _isRtl = false;
      if (sharedPref.containsKey('APP_LANGUAGE_IS_RTL'))
        _isRtl = sharedPref.getBool('APP_LANGUAGE_IS_RTL');

      if (language != null && language.trim() != "") {
        _language = language;
        _getLatestPlace(context);
        BlocProvider.of<LocalizationBloc>(context).add(FetchLocalization(_language));
    } else {
        return;
      }
    }
    Map<String, dynamic> languageDetails = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SelectLanguagePage(
          httpClient: widget.httpClient,
        ),
      ),
    );
    _appLanguageChanged(languageDetails);
  }

  void _appLanguageChanged(Map<String, dynamic> map) async {
    final sharedPref = await SharedPreferences.getInstance();
    final language = map['language'];
    final isRTL = map['rtl'] ?? false;
    if (language != null && language.trim() != "") {
      sharedPref.setString(APP_LANGUAGE, language);
      sharedPref.setBool('APP_LANGUAGE_IS_RTL', isRTL);
      _language = language;
      _isRtl = isRTL;
      _getLatestPlace(context);
      BlocProvider.of<LocalizationBloc>(context).add(ChangeLocalization(_language));
    } else {
      _getLanguage(context);
    }
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
    return BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (ctx, state) {
      if (state is LocalizationUnintialized || state is LocalizationLoading) {
        return _buildLoadingScaffold();
      } else if (state is LocalizationError) {
        BlocProvider.of<LocalizationBloc>(context).add(FetchLocalization(LOCALE_DEFAULT));
        return _buildLoadingScaffold();
      } else if (state is LocalizationLoaded) {
        if (_placeId == null) {
          return _buildLoadingScaffold();
        } else {
          return Directionality(
            textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: PlaceDetailsPage(
              placeId: _placeId,
              language: _language,
              httpClient: widget.httpClient,
              appTheme: widget.appTheme,
              appLanguageChanged: _appLanguageChanged,
            ),
          );
        }
      }
    });
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class PlaceDetailsPage extends StatefulWidget {
  final String placeId;
  final String language;
  final HttpClient httpClient;
  final AppTheme appTheme;
  final Function appLanguageChanged;
  const PlaceDetailsPage(
      {Key key,
      @required this.placeId,
      this.language = "en",
      this.httpClient,
      this.appTheme,
      this.appLanguageChanged})
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
            httpClient: widget.httpClient,
            appLanguageChanged: widget.appLanguageChanged,
            changeAppTheme: changeAppTheme,
            currentLanguge: widget.language,
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
              TriviaListCard(
                details: placeDetails.triviaListDetails,
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
                SizedBox(height: 4),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontStyle: FontStyle.italic),
                    children: [
                      if (!kIsWeb) //web not working for widget span
                        WidgetSpan(
                          child: Icon(Icons.info_outline,
                              size: 14,
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                      TextSpan(
                        text:
                            ' If you believe there is translation issue or any other issue with the content, please report ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      TextSpan(
                        text: 'here',
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
                    'Made with ❤️ in India',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
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
    Future<String> response = kDebugMode
        ? DefaultAssetBundle.of(context).loadString(
            'assets_remote/assets/json/$API_VERSION/${widget.placeId}/details_${widget.language}.json')
        : Repository.getResponse(
            httpClient: widget.httpClient,
            url:
                '$BASE_URL/assets/json/$API_VERSION/${widget.placeId}/details_${widget.language}.json',
            cacheTime: Duration(days: 7));

    return response
        .then((source) => Future.value(PlaceDetails.fromJson(source)));
  }
}
