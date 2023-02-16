import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_widget_mixin/platform_widget_mixin.dart';

import '../../blocs/page_fetch/page_fetch_state.dart';
import '../../data/remote/remote_repository.dart';
import '../../extensions/context_extensions.dart';
import '../../models/place_models/place_models.dart';
import '../../routes/routes_extra.dart';
import '../../widgets/adaptive_circular_loader.dart';
import '../home/bloc/home_bloc.dart';
import '../home/bloc/home_bloc_event.dart';
import '../place_details/components/basic_info/basic_info_app_bar.dart';
import '../place_details/widgets/attribution_widget.dart';
import 'bloc/places_page_fetch_bloc.dart';
import 'bloc/places_page_fetch_event.dart';

class PlacesListPage extends StatelessWidget
    with PlatformWidgetMixin, TitledPageMixin {
  const PlacesListPage({
    super.key,
  });

  @override
  Widget buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle(context) ?? ''),
      ),
      body: child,
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(pageTitle(context) ?? ''),
        previousPageTitle: previousPageTitle(context),
      ),
      child: child,
    );
  }

  @override
  Widget get child => BlocProvider<PlacesPageFetchBloc>(
        create: (context) {
          return PlacesPageFetchBloc(context.read<RemoteRepository>())
            ..add(PlacesPageFetchEvent(context.currentLanguage));
        },
        child:
            BlocBuilder<PlacesPageFetchBloc, PageFetchState<List<PlaceInfo>>>(
                builder: (_, state) {
          return state.when(
            uninitialized: _loadingBuilder,
            loaded: _loadedBuilder,
            loading: _loadingBuilder,
            error: _errorBuilder,
          );
        }),
      );

  Widget _errorBuilder(_) {
    return Builder(builder: (context) {
      return Center(
        child: Text(context.l10n.error_while_fetching_data),
      );
    });
  }

  Widget _loadingBuilder() {
    return const Center(child: AdaptiveCircularLoader());
  }

  Widget _loadedBuilder(List<PlaceInfo> places) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (ctx, index) {
        final item = places[index];
        return _PlaceInfoTile(
          key: ValueKey(item.id),
          placeInfo: item,
          onTap: () {
            ctx
              ..read<HomeBloc>().add(HomeBlocEvent.changePlace(item.id))
              ..pop();
          },
        );
      },
      itemCount: places.length,
    );
  }
}

class _PlaceInfoTile extends StatelessWidget with PlatformWidgetMixin {
  final PlaceInfo placeInfo;
  final VoidCallback? onTap;

  const _PlaceInfoTile({
    super.key,
    required this.placeInfo,
    this.onTap,
  });

  @override
  Widget? get child {
    return Builder(builder: (context) {
      return Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: CardBackgroundWidget(
              url: placeInfo.backgroundImage,
              boxFit: BoxFit.cover,
            ),
          ),
          _PlaceInfoTileFooter(placeInfo: placeInfo),
        ],
      );
    });
  }

  @override
  Widget buildAndroid(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }

  @override
  Widget buildIOS(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      child: child!,
    );
  }
}

class _PlaceInfoTileFooter extends StatelessWidget {
  const _PlaceInfoTileFooter({
    required this.placeInfo,
  });

  final PlaceInfo placeInfo;

  @override
  Widget build(BuildContext context) {
    Color? highlightTextColor = context.hightlightColor;

    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              placeInfo.name,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: highlightTextColor,
                fontSize: 28.0,
              ),
            ),
            if (placeInfo.country != null)
              Text(
                placeInfo.country!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: highlightTextColor,
                  fontSize: 18.0,
                ),
              ),
            AttributionWidget(
              photoBy: placeInfo.photoBy,
              attributionUrl: placeInfo.attributionUrl,
              licence: placeInfo.licence,
              textColor: highlightTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
