import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_fetch_state.freezed.dart';

@freezed
abstract class PageFetchState<T> with _$PageFetchState<T> {
  const factory PageFetchState.uninitialized() = _Uninitialized;
  const factory PageFetchState.loaded(T data) = _Loaded;
  const factory PageFetchState.loading() = _Loading;
  const factory PageFetchState.error(Error error) = _LoadFailure;
}
