import 'package:go_router/go_router.dart';

import '../app_language/select_language_page.dart';
import '../places/places_list_page.dart';
import '../screens/app_settings/app_settings_screen.dart';
import '../screens/home/home.dart';
import 'titled_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'app_settings',
          builder: (_, state) => TitledPage.goRouterState(
              state: state, child: const AppSettingsScreen()),
        ),
        GoRoute(
          path: 'places_list',
          builder: (_, state) => TitledPage.goRouterState(
            state: state,
            child: const PlacesListPage(),
          ),
        ),
        GoRoute(
          path: 'select_language',
          builder: (context, state) => TitledPage.goRouterState(
            state: state,
            child: const SelectLanguagePage(),
          ),
        ),
      ],
    ),
  ],
);
