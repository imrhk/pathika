import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart' as uio;

import './localization.dart';
import '../common/constants.dart';
import '../core/assets_client.dart';
import '../core/repository.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  final uio.HttpClient httpClient;
  final AssetsClient assetsClient;

  LocalizationBloc({required this.httpClient, required this.assetsClient})
      : super(LocalizationUnintialized()) {
    on<LocalizationEvent>((event, emit) {
      if (event is FetchLocalization) {
        _onFetchLocalizationEvent(event, emit);
      } else {
        emit(LocalizationError());
      }
    });
  }

  FutureOr<void> _onFetchLocalizationEvent(
    LocalizationEvent event,
    Emitter<LocalizationState> emit,
  ) async {
    if (event is FetchLocalization || event is ChangeLocalization) {
      emit(LocalizationLoading());
    }
    _getLocalization(event.locale, emit);
  }

  FutureOr<void> _getLocalization(
      String language, Emitter<LocalizationState> emit) async {
    Map<String, String> items = HashMap();
    int eventsYield = 0;

    //Load default locale
    try {
      String? data = await assetsClient
          .loadStringAsset('$baseLocalizationAssetPath/$localeDefault.json');
      if (data == null) {
        throw Exception();
      }
      items.addAll((json.decode(data) as Map).map<String, String>(
          (key, value) => MapEntry<String, String>(key, value.toString())));
      emit(LocalizationLoaded(items: HashMap.from(items)));
      eventsYield++;
    } catch (_) {
      if (kDebugMode) {
        print('Could not load default locale resources');
      }
    }

    //Load actual locale from assets
    try {
      String? data = await assetsClient
          .loadStringAsset('$baseLocalizationAssetPath/$language.json');
      if (data == null) {
        throw Exception();
      }
      Map<String, String>? map = (json.decode(data) as Map).map<String, String>(
          (key, value) => MapEntry<String, String>(key, value.toString()));
      if (!_isSame(items, map)) {
        items.addAll(map);
        emit(LocalizationLoaded(items: HashMap.from(items)));
        eventsYield++;
      }
    } catch (_) {
      if (kDebugMode) {
        print('Could not load selected locale $language resources');
      }
    }

    //Load remote locale
    try {
      String? data = await Repository.getResponse(
          httpClient: httpClient,
          cacheTime: const Duration(
            days: 1,
          ),
          url: '$baseUrl/assets/json/$apiVersion/localization_$language.json');
      if (data == null) {
        throw Exception();
      }
      Map<String, String> map = (json.decode(data) as Map)
          .map<String, String>((key, value) => MapEntry(key, value.toString()));
      if (!_isSame(items, map)) {
        items.addAll(map);
        emit(LocalizationLoaded(items: HashMap.from(items)));
        eventsYield++;
      }
    } catch (_) {
      if (kDebugMode) {
        print('Could not load selected locale $language resources');
      }
    }

    if (eventsYield == 0) {
      emit(LocalizationError());
    }
  }

  String localize(String text, String defaultValue) {
    if (state is LocalizationLoaded) {
      final value = (state as LocalizationLoaded).items[text];
      return value ?? defaultValue;
    }
    return defaultValue;
  }

  bool _isSame(Map<String, String>? map1, Map<String, String>? map2) {
    if (map1 == null && map2 == null) return true;
    if (map2 == null || map1 == null) return false;

    if (map1.length != map2.length) return false;
    final iterator1 = (HashMap()..addEntries(map1.entries)).entries.iterator;
    final iterator2 = (HashMap()..addEntries(map2.entries)).entries.iterator;
    while (iterator1.moveNext() && iterator2.moveNext()) {
      if (iterator1.current.key != iterator2.current.key) return false;
      if (iterator1.current.value != iterator2.current.key) return false;
    }
    return true;
  }
}
