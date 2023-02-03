import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../../remote/remote_repository.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_theme_bloc.dart';
import '../../theme/app_theme_event.dart';
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
    FirebaseMessagingSubscriptionManager().requestPermission();
  }

  void _appLanguageChanged(String language) async {
    final localizationBloc = context.read<LocalizationBloc>();
    localizationBloc.add(ChangeLocalization(language));
    await FirebaseMessagingSubscriptionManager().onLanguageChanged(language);
  }

  void _appThemeChanged(String theme) async {
    final appThemeBloc = context.read<AppThemeBloc>();
    final newAppThemeData = appThemeMap[theme]?.call();
    if (newAppThemeData != null) {
      appThemeBloc.add(ChangeAppTheme(newAppThemeData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(context.read<RemoteRepository>())
        ..add(const HomeBlocEvent.initialize()),
      child: BlocBuilder<HomeBloc, HomeBlocState>(builder: (context, state) {
        return state.when(
          uninitialized: _homeLoading,
          loading: _homeLoading,
          error: _homeError,
          loaded: _homeLoaded,
        );
      }),
    );
  }

  Widget _homeLoaded(String placeId) {
    return BlocConsumer<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return state.when(
          uninitialized: _appSettingsloadingBuilder,
          loaded: _appSettingsLoadedBuilder,
          loading: _appSettingsloadingBuilder,
        );
      },
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          loaded: (appSetting) {
            _appLanguageChanged(appSetting.language);
            _appThemeChanged(appSetting.theme);
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

  Widget _appSettingsLoadedBuilder(AppSettings appSetting) {
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
                    BlocProvider.of<LocalizationBloc>(context)
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
          child: const PlaceDetailsPage(),
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
