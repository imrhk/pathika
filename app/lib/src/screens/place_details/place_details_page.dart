import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';
import 'package:universal_io/io.dart' show Platform;
import 'package:url_launcher/url_launcher.dart';

import '../../ads/app_ad_widget.dart';
import '../../blocs/page_fetch/page_fetch_state.dart';
import '../../constants/route_constants.dart';
import '../../core/adt_details.dart';
import '../../data/remote/remote_repository.dart';
import '../../extensions/context_extensions.dart';
import '../../models/place_models/place_models.dart';
import '../../routes/routes_extra.dart';
import '../../widgets/adaptive_circular_loader.dart';
import '../../widgets/adaptive_icon_button.dart';
import '../../widgets/adaptive_scaffold.dart';
import '../../widgets/translate_list_item.dart';
import '../app_settings/app_settings_page.dart';
import '../app_settings/bloc/app_settings_bloc.dart';
import '../app_settings/bloc/app_settings_state.dart';
import '../home/bloc/home_bloc.dart';
import '../home/bloc/home_bloc_event.dart';
import 'bloc/place_details_fetch_bloc.dart';
import 'bloc/place_details_fetch_event.dart';
import 'components/airport/airport_card.dart';
import 'components/basic_info/basic_info_app_bar.dart';
import 'components/climate/climate_card.dart';
import 'components/country/country_card.dart';
import 'components/currency/currency_card.dart';
import 'components/dance/dance_card.dart';
import 'components/famous_people/person_list_card.dart';
import 'components/food/food_items_list_card.dart';
import 'components/industries/industry_card.dart';
import 'components/language/language_card.dart';
import 'components/location_map/location_map_card.dart';
import 'components/movies/movies_list_card.dart';
import 'components/sports/sports_card.dart';
import 'components/time/current_time_card.dart';
import 'components/time_to_visit/time_to_visit_card.dart';
import 'components/tourist_attractions/tourist_attractions_card.dart';
import 'components/trivia/trivia_card.dart';
import 'widgets/conver_photo_attribution_widget.dart';

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
            child: AppSettingsPage(),
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
      final errorOccured = context.l10n.error_occured;
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
        _PlacesDetailsScreenAppBar(details: widget.details),
        if (Platform.isIOS)
          SliverToBoxAdapter(
            child: _getBasicInfoWidget(context, widget.details),
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
                        text: context.l10n.report_issue,
                      ),
                      TextSpan(
                        text: ' ${context.l10n.here} ',
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
                    context.l10n.made_in_india,
                    style: context.theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                if (Platform.isAndroid || Platform.isIOS) const AppAdWidget(),
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
}

class _PlacesDetailsScreenAppBar extends StatelessWidget
    with PlatformWidgetMixin {
  final PlaceDetails details;

  const _PlacesDetailsScreenAppBar({required this.details});

  @override
  Widget buildAndroid(BuildContext context) {
    final mQuery = MediaQuery.of(context);
    final height = mQuery.size.height;

    return SliverAppBar(
      expandedHeight: height * 0.5,
      floating: false,
      pinned: true,
      flexibleSpace: _getBasicInfoWidget(context, details),
      actions: <Widget>[
        IconButton(
            tooltip: context.l10n.browse,
            onPressed: () => _onPressedDiscoverIcon(context),
            icon: const Icon(
              Icons.list_alt,
            ))
      ],
    );
  }

  void _onPressedDiscoverIcon(BuildContext context) {
    context.push('/$placesListPath',
        extra:
            PlacesListPageData(previousTitle: details.basicInfo?.name ?? ''));
  }

  void _onPressedAppSettingsIcon(BuildContext context) {
    context.push('/$appSettingsPath',
        extra:
            AppSettingsPageData(previousTitle: details.basicInfo?.name ?? ''));
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoSliverNavigationBar(
      automaticallyImplyLeading: false,
      largeTitle: Text(details.basicInfo?.name ?? ''),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (kDebugMode)
            AdaptiveIconButton(
                icon: const Icon(CupertinoIcons.refresh_bold,
                    color: CupertinoColors.activeBlue),
                onPressed: () => _onRefreshButtonTap(context)),
          if (kDebugMode) const SizedBox(width: 10),
          AdaptiveIconButton(
            icon: const Icon(CupertinoIcons.square_list,
                color: CupertinoColors.activeBlue),
            onPressed: () => _onPressedDiscoverIcon(context),
          ),
          const SizedBox(width: 10),
          AdaptiveIconButton(
            icon: const Icon(CupertinoIcons.settings,
                color: CupertinoColors.activeBlue),
            onPressed: () => _onPressedAppSettingsIcon(context),
          ),
        ],
      ),
    );
  }

  void _onRefreshButtonTap(BuildContext context) {
    final currentPlaceId = context.currentPlace;
    if (currentPlaceId != null) {
      context.read<PlaceDetailsFetchBloc>().add(
            PlaceDetailsFetchEvent(
              currentPlaceId,
              context.currentLanguage,
            ),
          );
    } else {
      context.read<HomeBloc>().add(const HomeBlocEvent.refresh());
    }
  }
}

Widget _getBasicInfoWidget(
  BuildContext context,
  PlaceDetails placeDetails,
) {
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
