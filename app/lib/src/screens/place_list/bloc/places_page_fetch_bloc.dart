import 'package:logger/logger.dart';

import '../../../blocs/page_fetch/page_fetch_bloc.dart';
import '../../../data/remote/remote_repository.dart';
import '../../../models/place_models/place_models.dart';
import 'places_page_fetch_event.dart';

class PlacesPageFetchBloc
    extends PageFetchBloc<PlacesPageFetchEvent, List<PlaceInfo>> {
  final RemoteRepository remoteRepository;

  PlacesPageFetchBloc(this.remoteRepository, [Logger? logger]) : super(logger);

  @override
  Future<List<PlaceInfo>> fetchPage(PlacesPageFetchEvent event) {
    return remoteRepository
        .getPlaces(event.appLanguage)
        .then((value) => value.reversed.toList());
  }
}
