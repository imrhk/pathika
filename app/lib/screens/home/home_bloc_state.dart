import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/app_error.dart';

part 'home_bloc_state.freezed.dart';

@freezed
class HomeBlocState with _$HomeBlocState {
  const factory HomeBlocState.uninitialized() = _Uninitialized;
  const factory HomeBlocState.loaded(String placeId) = _Loaded;
  const factory HomeBlocState.loading() = _Loading;
  const factory HomeBlocState.error(AppError error) = _AppError;
}
