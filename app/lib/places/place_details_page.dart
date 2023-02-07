import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:url_launcher/url_launcher.dart';

import '../ads/app_ad_widget.dart';
import '../airport/airport_card.dart';
import '../basic_info/basic_info_app_bar.dart';
import '../climate/climate_card.dart';
import '../core/adt_details.dart';
import '../country/country_card.dart';
import '../currency/currency_card.dart';
import '../dance/dance_card.dart';
import '../extensions/context_extensions.dart';
import '../famous_people/person_list_card.dart';
import '../food/food_items_list_card.dart';
import '../industries/industry_card.dart';
import '../language/language_card.dart';
import '../location_map/location_map_card.dart';
import '../models/place_models.dart';
import '../movies/movies_list_card.dart';
import '../page_fetch/page_fetch_state.dart';
import '../remote/remote_repository.dart';
import '../screens/app_settings/app_settings_bloc.dart';
import '../screens/app_settings/app_settings_state.dart';
import '../screens/app_settings/app_settings_widget.dart';
import '../sports/sports_card.dart';
import '../time/current_time_card.dart';
import '../time_to_visit/time_to_visit_card.dart';
import '../tourist_attractions/tourist_attractions_card.dart';
import '../trivia/trivia_card.dart';
import '../widgets/adaptive_circular_loader.dart';
import '../widgets/adaptive_scaffold.dart';
import '../widgets/conver_photo_attribution_widget.dart';
import '../widgets/translate_list_item.dart';
import 'place_details_fetch_bloc/place_details_fetch_bloc.dart';
import 'place_details_fetch_bloc/place_details_fetch_event.dart';

class PlaceDetailsPage extends StatelessWidget {
  const PlaceDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: AdaptiveScaffold(
        appDrawer: const SafeArea(
          child: Drawer(
            child: AppSettingsWidget(),
          ),
        ),
        body: BlocProvider<PlaceDetailsFetchBloc>(
          create: (context) {
            return PlaceDetailsFetchBloc(context.read<RemoteRepository>())
              ..add(PlaceDetailsFetchEvent(
                context.currentPlace!,
                context.currentLanguage,
              ));
          },
          child: BlocListener<AppSettingsBloc, AppSettingsState>(
            listenWhen: (previous, current) =>
                previous.whenOrNull<String?>(
                  loaded: (appSetting) => appSetting.language,
                ) !=
                current.whenOrNull<String?>(
                  loaded: (appSetting) => appSetting.language,
                ),
            listener: (context, state) {
              state.maybeWhen(
                orElse: () => {},
                loaded: (appSetting) {
                  context
                      .read<PlaceDetailsFetchBloc>()
                      .add(PlaceDetailsFetchEvent(
                        context.currentPlace!,
                        appSetting.language,
                      ));
                },
              );
            },
            child: BlocBuilder<PlaceDetailsFetchBloc,
                PageFetchState<PlaceDetails>>(
              builder: (context, state) {
                return state.when(
                    uninitialized: _loadingBuilder,
                    loaded: _loadedBuilder,
                    loading: _loadingBuilder,
                    error: _errorBuilder);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingBuilder() {
    return const Center(
      child: AdaptiveCircularLoader(),
    );
  }

  Widget _loadedBuilder(PlaceDetails details) {
    return PlaceDetailsWidget(details: details);
  }

  Widget _errorBuilder(Error error) {
    return Builder(builder: (context) {
      final errorOccured = context.localize('error_occured', 'Error occured');
      final msg = '$errorOccured\n${error.toString()}';
      return Center(child: Text(msg));
    });
  }
}

class PlaceDetailsWidget extends StatefulWidget {
  final PlaceDetails details;

  const PlaceDetailsWidget({super.key, required this.details});

  @override
  State<PlaceDetailsWidget> createState() => _PlaceDetailsWidgetState();
}

class _PlaceDetailsWidgetState extends State<PlaceDetailsWidget> {
  double _previousOffset = -1;
  final ScrollController _scrollController = ScrollController();
  ScrollDirection _verticalScrollDirection = ScrollDirection.idle;

  bool isFirst = false;
  bool showVeg = true;

  String? climateValue;

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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        getSliverAppBar(context, widget.details),
        if (Platform.isIOS)
          SliverToBoxAdapter(
            child: getBasicInfoWidget(widget.details),
          ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            (<Widget>[
              if (widget.details.countryDetails != null)
                CountryCard(
                  details: widget.details.countryDetails!,
                ),
              if (widget.details.languageDetails != null)
                LanguageCard(
                  details: widget.details.languageDetails!,
                ),
              if (widget.details.currencyDetails != null)
                CurrencyCard(
                  details: widget.details.currencyDetails!,
                ),
              if (widget.details.timezoneOffsetInMinutes != null)
                CurrentTimeCard(
                  timezoneOffsetInMinute:
                      widget.details.timezoneOffsetInMinutes!,
                ),
              if (widget.details.climateDetails != null)
                ClimateCard(
                  details: widget.details.climateDetails!,
                ),
              if (widget.details.timeToVisitDetails != null)
                TimeToVisitCard(
                  details: widget.details.timeToVisitDetails!,
                ),
              if (widget.details.touristPlacesList != null)
                TouristAttractionsCard(
                    details: widget.details.touristPlacesList!.items),
              if (widget.details.foodItemsList != null)
                FoodItemsListCard(
                  details: widget.details.foodItemsList!.items,
                ),
              if (widget.details.personsList != null)
                PersonListCard(
                  details: widget.details.personsList!.items,
                ),
              if (widget.details.moviesList != null)
                MoviesListCard(
                  details: widget.details.moviesList!.items,
                  countryName: widget.details.countryDetails!.name,
                ),
              if (widget.details.danceDetails != null)
                DanceCard(
                  details: widget.details.danceDetails!,
                ),
              if (widget.details.sportsDetails != null)
                SportsCard(
                  details: widget.details.sportsDetails!,
                ),
              if (widget.details.industriesDetails != null)
                IndustriesCard(
                  details: widget.details.industriesDetails!,
                ),
              if (widget.details.airport != null)
                AirportCard(
                  details: widget.details.airport!,
                ),
              if (widget.details.locationMapList != null)
                LocationMapCard(
                  details: widget.details.locationMapList!.items,
                ),
              if (widget.details.triviaListDetails != null)
                TriviaListCard(
                  details: widget.details.triviaListDetails!.items,
                ),
            ]..removeWhere((element) =>
                    element is Details && (element as Details).details == null))
                .map(
                  (widget) => Platform.isIOS
                      ? Theme(
                          data: context.currentTheme.themeDataMaterial ??
                              ThemeData.light(),
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
                  if (widget.details.basicInfo != null)
                    CoverPhotoAttributionWidget(
                        placeInfo: widget.details.basicInfo!),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: context.theme.textTheme.bodySmall
                        ?.copyWith(fontStyle: FontStyle.italic),
                    children: [
                      if (!kIsWeb) //web not working for widget span
                        const WidgetSpan(
                          child: Icon(
                            Icons.info_outline,
                            size: 14,
                          ),
                        ),
                      TextSpan(
                        text: context.localize('report_issue',
                            ' If you believe there is translation issue or any other issue with the content, please report '),
                      ),
                      TextSpan(
                        text: ' ${context.localize('_here', ' here')} ',
                        style: const TextStyle(
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
                            child: const Icon(
                              Icons.open_in_new,
                              size: 14,
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
                    context.localize('made_in_india', 'Made with ❤️ in India'),
                    style: context.theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const AppAdWidget(),
              ],
            ),
          ),
        ),
      ],
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
            child: const Icon(CupertinoIcons.square_list,
                color: CupertinoColors.activeBlue),
            onTap: () => context.push('/places_list'),
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
                          context.localize('_settings', 'Settings'),
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
                    child: const AppSettingsWidget(),
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
        IconButton(
            tooltip: context.localize('browse', 'Browse'),
            onPressed: () => context.push('/places_list'),
            icon: const Icon(
              Icons.list_alt,
            ))
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
        placeInfo: placeDetails.basicInfo!,
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

  _openForm() async {
    launchUrl(Uri.parse('https://forms.gle/bb3LZhreSfeHHy1f6'));
  }
}
