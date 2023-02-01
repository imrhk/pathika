import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PageFetchState<T> extends Equatable {
  @override
  List<Object?> get props => [];
  @override
  bool? get stringify => true;
}

class Uninitialized<T> extends PageFetchState<T> {}

class Loaded<T> extends PageFetchState<T> {
  final T data;

  Loaded(this.data);

  @override
  List<Object?> get props => [data];

  @override
  bool? get stringify => true;
}

class Loading<T> extends PageFetchState<T> {}

class LoadFailure<T> extends PageFetchState<T> {
  final Error error;

  LoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}
