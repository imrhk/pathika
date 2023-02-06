import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../common/widgets/adaptive_app_bar.dart';
import '../../common/widgets/adaptive_circular_loader.dart';
import '../../core/app_error.dart';
import '../../firebase_messaging_subscription_manager.dart';
import '../../localization/constants.dart';
import '../../localization/localization_bloc.dart';
import '../../localization/localization_event.dart';
import '../../localization/localization_state.dart';
import '../../models/app_settings.dart';
import '../../places/place_details_page.dart';
import '../app_settings/app_settings_bloc.dart';
import '../app_settings/app_settings_state.dart';
import 'home_bloc.dart';
import 'home_bloc_event.dart';
import 'home_bloc_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // TODO: Defer it to 30 seconds post usage
    FirebaseMessagingSubscriptionManager(context.read<Logger>())
        .requestPermission();
  }

  void _appLanguageChanged(String language) async {
    //context.read<LocalizationBloc>().add(ChangeLocalization(language));
    await FirebaseMessagingSubscriptionManager(context.read<Logger>())
        .onLanguageChanged(language);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeBlocState>(builder: (context, state) {
      return state.when(
        uninitialized: _homeLoading,
        loading: _homeLoading,
        error: _homeError,
        loaded: _homeLoaded,
      );
    });
  }

  Widget _homeLoaded(String placeId) {
    return BlocConsumer<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return state.when(
          uninitialized: _appSettingsloadingBuilder,
          loaded: (appSettings) =>
              _appSettingsLoadedBuilder(appSettings, placeId),
          loading: _appSettingsloadingBuilder,
        );
      },
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          loaded: (appSetting) {
            _appLanguageChanged(appSetting.language);
          },
        );
      },
    );
  }

  Widget _homeLoading() {
    return const AdaptiveScaffold(
      body: Center(child: AdaptiveCircularLoader()),
    );
  }

  Widget _homeError(AppError error) {
    return Builder(builder: (context) {
      return AdaptiveScaffold(
        body: Center(
          child: Column(
            children: [
              Text(error.msg),
              TextButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(const HomeBlocEvent.refresh());
                  },
                  child: const Text('Retry'))
            ],
          ),
        ),
      );
    });
  }

  Widget _appSettingsloadingBuilder() {
    return const Center(child: AdaptiveCircularLoader());
  }

  Widget _appSettingsLoadedBuilder(AppSettings appSetting, String placeId) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (ctx, state) {
      if (state is LocalizationError) {
        return AdaptiveScaffold(
          body: Center(
            child: Column(
              children: [
                const Text('Error while loading l10n'),
                TextButton(
                  onPressed: () {
                    context
                        .read<LocalizationBloc>()
                        .add(const FetchLocalization(localeDefault));
                  },
                  child: const Text('Retry'),
                )
              ],
            ),
          ),
        );
      } else if (state is LocalizationLoaded) {
        return Directionality(
          textDirection:
              appSetting.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: PlaceDetailsPage(
            key: ValueKey(placeId),
          ),
        );
      } else {
        return const AdaptiveScaffold(
          body: Center(
            child: AdaptiveCircularLoader(),
          ),
        );
      }
    });
  }
}
