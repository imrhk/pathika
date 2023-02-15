import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../core/app_error.dart';
import '../../utils/firebase_messaging_subscription_manager.dart';
import '../../widgets/adaptive_circular_loader.dart';
import '../../widgets/adaptive_scaffold.dart';
import '../app_settings/bloc/app_settings_bloc.dart';
import '../app_settings/bloc/app_settings_state.dart';
import '../place_details/place_details_page.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_bloc_event.dart';
import 'bloc/home_bloc_state.dart';

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
          loaded: (_) => _appSettingsLoadedBuilder(placeId),
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

  Widget _appSettingsLoadedBuilder(String placeId) {
    return PlaceDetailsPage(
      key: ValueKey(placeId),
    );
  }
}
