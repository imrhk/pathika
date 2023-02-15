import '../../../blocs/page_fetch/page_fetch_event.dart';

class PlacesPageFetchEvent extends PageFetchEvent {
  final String appLanguage;

  const PlacesPageFetchEvent(this.appLanguage);

  @override
  List<Object?> get props => [appLanguage];

  @override
  bool? get stringify => true;
}
