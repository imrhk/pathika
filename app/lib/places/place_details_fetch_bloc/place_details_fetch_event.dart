import '../../page_fetch/page_fetch_event.dart';

class PlaceDetailsFetchEvent extends PageFetchEvent {
  final String placeId;
  final String appLanguage;

  const PlaceDetailsFetchEvent(this.placeId, this.appLanguage);

  @override
  List<Object?> get props => [placeId, appLanguage];

  @override
  bool? get stringify => true;
}
