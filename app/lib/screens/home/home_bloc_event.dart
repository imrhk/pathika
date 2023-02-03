import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_bloc_event.freezed.dart';

@freezed
class HomeBlocEvent with _$HomeBlocEvent {
  const factory HomeBlocEvent.initialize() = _Initialize;
  const factory HomeBlocEvent.refresh() = _Refresh;
  const factory HomeBlocEvent.changePlace(String placeId) = _ChangePlace;
}
