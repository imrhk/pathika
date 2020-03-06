import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:universal_io/io.dart' as UIO;

import './localization.dart';
import '../common/constants.dart';
import '../core/assets_client.dart';
import '../core/repository.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  final UIO.HttpClient httpClient;
  final AssetsClient assetsClient;

  LocalizationBloc({@required this.httpClient, @required this.assetsClient})
      : assert(httpClient != null),
        assert(assetsClient != null);

  @override
  LocalizationState get initialState => LocalizationUnintialized();

  @override
  Stream<LocalizationState> mapEventToState(LocalizationEvent event) async* {
    if (event is FetchLocalization || event is ChangeLocalization) {
      yield LocalizationLoading();

      yield* _getLocalization(event.locale);
    } else {
      yield LocalizationError();
    }
  }

  Stream<LocalizationState> _getLocalization(String language) async* {
    Map<String, String> items = HashMap();
    int eventsYield = 0;

    //Load default locale
    try {
      String data = await assetsClient.loadStringAsset(
          '$BASE_LOCALIZATION_ASSET_PATH/$LOCALE_DEFAULT.json');
      items.addAll((json.decode(data) as Map).map<String, String>(
          (key, value) => MapEntry<String, String>(key, value.toString())));
      yield LocalizationLoaded(items: HashMap.from(items));
      eventsYield++;
    } catch (_) {
      print('Could not load default locale resources');
    }

    //Load actual locale from assets
    try {
      String data = await assetsClient
          .loadStringAsset('$BASE_LOCALIZATION_ASSET_PATH/$language.json');
      Map map = (json.decode(data) as Map).map<String, String>(
          (key, value) => MapEntry<String, String>(key, value.toString()));
      if (!_isSame(items, map)) {
        items.addAll(map);
        yield LocalizationLoaded(items: HashMap.from(items));
        eventsYield++;
      }
    } catch (_) {
      print('Could not load selected locale $language resources');
    }

    //Load remote locale
    try {
      String data = await Repository.getResponse(
          httpClient: httpClient,
          cacheTime: Duration(
            days: 1,
          ),
          url:
              '$BASE_URL/assets/json/$API_VERSION/localization_$language.json');
      Map map = (json.decode(data) as Map).map<String, String>(
          (key, value) => MapEntry(key, value.toString()));
      if (!_isSame(items, map)) {
        items.addAll(map);
        yield LocalizationLoaded(items: HashMap.from(items));
        eventsYield++;
      }
    } catch (_) {
      print('Could not load selected locale $language resources');
    }

    if (eventsYield == 0) {
      yield LocalizationError();
    }
  }

  String localize(String text, String defaultValue) {
    if (state is LocalizationLoaded) {
      final value = (state as LocalizationLoaded).items[text];
      return value ?? defaultValue;
    }
    return defaultValue;
  }

  bool _isSame(Map<String, String> map1, Map<String, String> map2) {
    if (map1 == null && map2 == null) return true;
    if (map1 == null || map2 == null) return false;
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
