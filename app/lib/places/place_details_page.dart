import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../basic_info/basic_info.dart';
import '../theme/app_theme_bloc.dart';
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
  final void Function(Map<String, dynamic>)? appLanguageChanged;
  final void Function(String)? changePlace;
  const PlaceDetailsPage({
    super.key,
    required this.placeId,
    this.language = "en",
    required this.httpClient,
    this.appLanguageChanged,
    this.changePlace,
  });

  @override
  State createState() {
    return _PlaceDetailsPageState();
  }
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  bool isFirst = false;
  bool showVeg = true;

  String? climateValue;

  double _previousOffset = -1;
  final ScrollController _scrollController = ScrollController();
  ScrollDirection _verticalScrollDirection = ScrollDirection.idle;

  final adConfig = getAdConfig();
  BannerAd? bottomBarPromoAd;

  _PlaceDetailsPageState() {
    bottomBarPromoAd = adConfig != null
        ? BannerAd(
            size: AdSize.banner,
            adUnitId: adConfig!.adsId[placesBottomBarPromo]!,
            listener: const BannerAdListener(),
            request: adRequest)
        : null;
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
    bottomBarPromoAd?.load();
  }

  Widget _buildMaterialAppDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: AppSettings(
          httpClient: widget.httpClient,
          appLanguageChanged: widget.appLanguageChanged,
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
        return FadeTransition(opacity: animation, child: child);
      },
      child: AppScaffold(
        getAppDrawer: _buildMaterialAppDrawer,
        body: getPlacesDetailsWidget(),
      ),
    );
  }

  Widget getPlacesDetailsWidget() {
    return FutureBuilder<PlaceDetails?>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                '${BlocProvider.of<LocalizationBloc>(context).localize('error_occured', 'Error occured')}\n ${snapshot.error.toString()}'),
          );
        } else {
          return mapPlaceDetailsDataToUI(context, snapshot.data!);
        }
      },
      initialData: PlaceDetails.empty(),
      future: _getData(),
    );
  }

  Widget getCupertinoAppBar(PlaceDetails placeDetails) {
    return CupertinoSliverNavigationBar(
      automaticallyImplyLeading: false,
      largeTitle: Text(placeDetails.basicInfo?.name ?? ''),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (kDebugMode)
            GestureDetector(
                child: const Icon(CupertinoIcons.refresh_bold,
                    color: CupertinoColors.activeBlue),
                onTap: () {
                  setState(() {});
                }),
          if (kDebugMode) const SizedBox(width: 10),
          GestureDetector(
            child: const Icon(CupertinoIcons.placemark,
                color: CupertinoColors.activeBlue),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: GestureDetector(
                        child: Text(
                          BlocProvider.of<LocalizationBloc>(context)
                              .localize('_discover', 'Discover'),
                        ),
                      ),
                      leading: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            const Icon(CupertinoIcons.left_chevron,
                                color: CupertinoColors.activeBlue),
                            Flexible(
                              child: Text(
                                placeDetails.basicInfo?.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
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
              );
            },
          ),
          const SizedBox(width: 10),
          GestureDetector(
            child: const Icon(CupertinoIcons.settings,
                color: CupertinoColors.activeBlue),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: GestureDetector(
                        child: Text(
                          BlocProvider.of<LocalizationBloc>(context)
                              .localize('_settings', 'Settings'),
                        ),
                      ),
                      leading: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            const Icon(CupertinoIcons.left_chevron,
                                color: CupertinoColors.activeBlue),
                            Flexible(
                              child: Text(
                                placeDetails.basicInfo?.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
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
                      currentLanguge: widget.language,
                      changePlace: widget.changePlace,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
        if (kDebugMode)
          GestureDetector(
              child: const Icon(
                Icons.refresh,
              ),
              onTap: () {
                setState(() {});
              }),
        if (kDebugMode) const SizedBox(width: 10),
        GestureDetector(
          child: const Icon(Icons.search),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(
                      BlocProvider.of<LocalizationBloc>(context)
                          .localize('_discover', 'Discover'),
                    ),
                  ),
                  body: PlacesListPage(
                    httpClient: widget.httpClient,
                    changePlace: widget.changePlace,
                    currentLanguage: widget.language,
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

    if (placeDetails.basicInfo != null) {
      return BasicInfoAppBar(
        height: height * 0.5,
        orientation: orientation,
        basicInfo: placeDetails.basicInfo!,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getSliverAppBar(BuildContext context, PlaceDetails placeDetails) {
    if (Platform.isIOS) {
      return getCupertinoAppBar(placeDetails);
    } else {
      return getMaterialAppBar(placeDetails);
    }
  }

  Widget mapPlaceDetailsDataToUI(
      BuildContext context, PlaceDetails placeDetails) {
    ThemeData? materialThemeData = BlocProvider.of<AppThemeBloc>(context)
        .state
        .appThemeData
        .themeDataMaterial;
    Color? captionColor = BlocProvider.of<AppThemeBloc>(context)
        .state
        .appThemeData
        .themeDataMaterial
        ?.textTheme
        .bodySmall
        ?.color;
    Color? subtitleColor = BlocProvider.of<AppThemeBloc>(context)
        .state
        .appThemeData
        .themeDataMaterial
        ?.textTheme
        .bodySmall
        ?.color;

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        getSliverAppBar(context, placeDetails),
        if (Platform.isIOS)
          SliverToBoxAdapter(
            child: getBasicInfoWidget(placeDetails),
          ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            (<Widget>[
              if (placeDetails.countryDetails != null)
                CountryCard(
                  details: placeDetails.countryDetails!,
                ),
              if (placeDetails.languageDetails != null)
                LanguageCard(
                  details: placeDetails.languageDetails!,
                ),
              if (placeDetails.currencyDetails != null)
                CurrencyCard(
                  details: placeDetails.currencyDetails!,
                  httpclient: widget.httpClient,
                ),
              if (placeDetails.timezoneOffsetInMinutes != null)
                CurrentTimeCard(
                  timezoneOffsetInMinute: placeDetails.timezoneOffsetInMinutes!,
                ),
              if (placeDetails.climateDetails != null)
                ClimateCard(
                  details: placeDetails.climateDetails!,
                ),
              if (placeDetails.timeToVisitDetails != null)
                TimeToVisitCard(
                  details: placeDetails.timeToVisitDetails!,
                ),
              if (placeDetails.touristPlacesList != null)
                TouristAttractionsCard(
                  details: placeDetails.touristPlacesList!,
                ),
              if (placeDetails.foodItemsList != null)
                FoodItemsListCard(
                  details: placeDetails.foodItemsList!,
                ),
              if (placeDetails.personsList != null)
                PersonListCard(
                  details: placeDetails.personsList!,
                ),
              if (placeDetails.moviesList != null)
                MoviesListCard(
                  details: placeDetails.moviesList!,
                  countryName: placeDetails.countryDetails!.name,
                ),
              if (placeDetails.danceDetails != null)
                DanceCard(
                  details: placeDetails.danceDetails!,
                ),
              if (placeDetails.sportsDetails != null)
                SportsCard(
                  details: placeDetails.sportsDetails!,
                ),
              if (placeDetails.industriesDetails != null)
                IndustriesCard(
                  details: placeDetails.industriesDetails!,
                ),
              if (placeDetails.airport != null)
                AirportCard(
                  details: placeDetails.airport!,
                ),
              if (placeDetails.locationMapList != null)
                LocationMapCard(
                  details: placeDetails.locationMapList!,
                ),
              if (placeDetails.triviaListDetails != null)
                TriviaListCard(
                  details: placeDetails.triviaListDetails!,
                ),
            ]..removeWhere((element) =>
                    element is Details && (element as Details).details == null))
                .map(
                  (widget) => Platform.isIOS
                      ? Theme(
                          data: materialThemeData ?? ThemeData.light(),
                          child: widget)
                      : TranslateListItem(
                          traslateHeight: 600,
                          duration: const Duration(seconds: 1),
                          axis: Axis.vertical,
                          getScrollDirection: getVerticalScrollDirection,
                          child: widget),
                )
                .toList(),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 4,
              right: 10,
              left: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 4),
                const Divider(
                  thickness: 2,
                ),
                if (!Platform.isIOS)
                  getCoverPhotoAttribution(context, placeDetails.basicInfo),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontStyle: FontStyle.italic),
                    children: [
                      if (!kIsWeb) //web not working for widget span
                        WidgetSpan(
                          child: Icon(Icons.info_outline,
                              size: 14, color: captionColor),
                        ),
                      TextSpan(
                          text: BlocProvider.of<LocalizationBloc>(context).localize(
                              'report_issue',
                              ' If you believe there is translation issue or any other issue with the content, please report '),
                          style: TextStyle(color: captionColor)),
                      TextSpan(
                        text:
                            ' ${BlocProvider.of<LocalizationBloc>(context).localize('_here', ' here')} ',
                        style: TextStyle(
                            color: captionColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openForm();
                          },
                      ),
                      if (!kIsWeb)
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: _openForm,
                            child: Icon(
                              Icons.open_in_new,
                              size: 14,
                              color: captionColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    BlocProvider.of<LocalizationBloc>(context)
                        .localize('made_in_india', 'Made with ❤️ in India'),
                    style: TextStyle(fontSize: 16, color: subtitleColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _openForm() async {
    launchUrl(Uri.parse('https://forms.gle/bb3LZhreSfeHHy1f6'));
  }

  Future<PlaceDetails?> _getData() async {
    getResponse(String language) {
      return Repository.getResponse(
          httpClient: widget.httpClient,
          url:
              '$baseUrl/assets/json/$apiVersion/${widget.placeId}/details_$language.json',
          cacheTime: const Duration(days: 7));
    }

    String? response = await getResponse(widget.language);
    response ??= await getResponse('en');
    if (response != null) {
      return Future.value(PlaceDetails.fromJson(response));
    } else {
      return Future.value(null);
    }
  }
}

Widget getCoverPhotoAttribution(BuildContext context, BasicInfo? basicInfo) {
  Color? highlightTextColor = BlocProvider.of<AppThemeBloc>(context)
      .state
      .appThemeData
      .highlightTextColor;

  final String? text;
  if (basicInfo != null) {
    text = Platform.isIOS
        ? basicInfo.place
        : '${BlocProvider.of<LocalizationBloc>(context).localize('cover_photo_location', 'Cover photo location')}: ${basicInfo.place}';
  } else {
    text = null;
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      if (text != null)
        SizedBox(
          width: double.infinity,
          child: Text(
            text,
            textAlign: TextAlign.end,
            style: TextStyle(color: highlightTextColor),
          ),
        ),
      getAttributionWidget(context, basicInfo?.photoBy,
          basicInfo?.attributionUrl, basicInfo?.licence, highlightTextColor),
      const SizedBox(height: 4),
      const Divider(
        thickness: 2,
      )
    ],
  );
}

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Function? getAppBar;
  final Function? getAppDrawer;
  final Function? getNavigationbar;

  const AppScaffold({
    super.key,
    required this.body,
    this.getAppDrawer,
    this.getAppBar,
    this.getNavigationbar,
  });
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: getNavigationbar?.call(),
        child: body,
      );
    } else {
      return Scaffold(
        body: body,
        appBar: getAppBar?.call(),
        drawer: getAppDrawer?.call(context),
      );
    }
  }
}
