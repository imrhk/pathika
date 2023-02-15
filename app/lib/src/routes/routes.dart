import 'package:go_router/go_router.dart';

import '../constants/route_constants.dart';
import '../screens/app_settings/app_settings_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/place_list/places_list_page.dart';
import '../screens/select_language/select_language_page.dart';
import '../widgets/titled_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: appSettingsPath,
          builder: (_, state) => TitledPage.goRouterState(
              state: state, child: const AppSettingsScreen()),
        ),
        GoRoute(
          path: placesListPath,
          builder: (_, state) => TitledPage.goRouterState(
            state: state,
            child: const PlacesListPage(),
          ),
        ),
        GoRoute(
          path: selectLanguagePath,
          builder: (context, state) => TitledPage.goRouterState(
            state: state,
            child: const SelectLanguagePage(),
          ),
        ),
      ],
    ),
  ],
);
