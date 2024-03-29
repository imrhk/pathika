import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../blocs/page_fetch/page_fetch_bloc.dart';
import '../../../constants/localization_constants.dart';
import '../../../data/remote/remote_repository.dart';
import '../../../models/place_models/place_models.dart';
import 'place_details_fetch_event.dart';

class PlaceDetailsFetchBloc
    extends PageFetchBloc<PlaceDetailsFetchEvent, PlaceDetails> {
  final RemoteRepository remoteRepository;

  PlaceDetailsFetchBloc(this.remoteRepository, [Logger? logger])
      : super(logger);

  @override
  Future<PlaceDetails> fetchPage(PlaceDetailsFetchEvent event) async {
    try {
      final result = await remoteRepository.getPlaceDetails(
          event.placeId, event.appLanguage);
      return result;
    } catch (e) {
      if (e is DioError) {
        if (e.response?.statusCode == 404) {
          logger?.i("${event.appLanguage} not found, trying $localeDefault");
          return remoteRepository.getPlaceDetails(event.placeId, localeDefault);
        } else {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
  }
}
