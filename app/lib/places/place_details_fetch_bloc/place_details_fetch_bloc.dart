import 'package:logger/logger.dart';

import '../../models/place_models.dart';
import '../../page_fetch/page_fetch_bloc.dart';
import '../../remote/remote_repository.dart';
import 'place_details_fetch_event.dart';

class PlaceDetailsFetchBloc
    extends PageFetchBloc<PlaceDetailsFetchEvent, PlaceDetails> {
  final RemoteRepository remoteRepository;

  PlaceDetailsFetchBloc(this.remoteRepository, [Logger? logger])
      : super(logger);

  @override
  Future<PlaceDetails> fetchPage(PlaceDetailsFetchEvent event) {
    return remoteRepository.getPlaceDetails(event.placeId, event.appLanguage);
  }
}
