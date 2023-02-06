import 'package:go_router/go_router.dart';

import 'places/places_list_page.dart';
import 'screens/app_settings/app_settings_widget.dart';
import 'screens/home/home.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'app_settings',
          builder: (_, __) => const AppSettingsWidget(),
        ),
        GoRoute(
          path: 'places_list',
          builder: (_, __) => const PlacesListPage(),
        ),
      ],
    ),
  ],
);
