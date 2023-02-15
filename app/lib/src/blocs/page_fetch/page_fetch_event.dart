import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PageFetchEvent extends Equatable {
  const PageFetchEvent();
  @override
  List<Object?> get props => [];
  @override
  bool? get stringify => true;
}
