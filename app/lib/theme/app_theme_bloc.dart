import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'app_theme_event.dart';
import 'app_theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc() : super(AppThemeUninitalized()) {
    on<AppThemeInitialize>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (sharedPreferences.containsKey('APP_THEME')) {
        final appThemeValue = sharedPreferences.getString('APP_THEME');
        final appTheme = appThemeMap[appThemeValue]?.call();
        if (appTheme != null) {
          emit(AppThemeLoaded(appTheme));
          if (kDebugMode) {
            print('loading $appTheme}');
          }
        }
      } else {
        add(ChangeAppTheme(AppTheme.light()));
      }
    });

    on<ChangeAppTheme>((event, emit) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('APP_THEME', event.appThemeData.label);
      emit(AppThemeLoaded(event.appThemeData));
    });
  }
}
