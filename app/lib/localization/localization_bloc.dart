import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../assets/assets_repository.dart';
import '../remote/remote_repository.dart';
import 'localization.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  final RemoteRepository _remoteRepository;
  final AssetsRepository _assetsRepository;

  LocalizationBloc({
    required RemoteRepository remoteRepository,
    required AssetsRepository assetsRepository,
  })  : _remoteRepository = remoteRepository,
        _assetsRepository = assetsRepository,
        super(LocalizationUnintialized()) {
    on<FetchLocalization>(_onFetchLocalizationEvent);
    on<ChangeLocalization>(_onFetchLocalizationEvent);
  }

  FutureOr<void> _onFetchLocalizationEvent(
    LocalizationEvent event,
    Emitter<LocalizationState> emit,
  ) async {
    if (event is FetchLocalization || event is ChangeLocalization) {
      emit(LocalizationLoading());
    }
    await _getLocalization(event.locale, emit);
  }

  FutureOr<void> _getLocalization(
      String language, Emitter<LocalizationState> emit) async {
    Map<String, String> items = HashMap();
    int eventsEmitted = 0;

    //Load default locale
    try {
      items.addAll(await _assetsRepository.getLocalizations(localeDefault));
      emit(LocalizationLoaded(items: HashMap.from(items)));
      eventsEmitted++;
    } catch (_) {
      if (kDebugMode) {
        print('Could not load default locale resources');
      }
    }

    //Load actual locale from assets
    try {
      Map<String, String>? map =
          await _assetsRepository.getLocalizations(language);
      if (!mapEquals(items, map)) {
        items.addAll(map);
        emit(LocalizationLoaded(items: HashMap.from(items)));
        eventsEmitted++;
      }
    } catch (_) {
      if (kDebugMode) {
        print('Could not load selected locale $language resources');
      }
    }

    //Load remote locale
    try {
      final data = await _remoteRepository.getLocalization(language);
      Map<String, String> map = (json.decode(data) as Map)
          .map<String, String>((key, value) => MapEntry(key, value.toString()));
      if (!mapEquals(items, map)) {
        items.addAll(map);
        emit(LocalizationLoaded(items: HashMap.from(items)));
        eventsEmitted++;
      }
    } catch (_) {
      if (kDebugMode) {
        print('Could not load selected locale $language resources');
      }
    }

    if (eventsEmitted == 0) {
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
}
