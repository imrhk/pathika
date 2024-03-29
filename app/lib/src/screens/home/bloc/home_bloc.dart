import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../core/app_error.dart';
import '../../../data/remote/remote_repository.dart';
import 'home_bloc_event.dart';
import 'home_bloc_state.dart';

class HomeBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  final RemoteRepository _repository;

  HomeBloc(this._repository) : super(const HomeBlocState.uninitialized()) {
    on<HomeBlocEvent>((event, emit) async {
      await event.when(
          initialize: () async => await _mapInitializeToState(emit),
          refresh: () async => await _mapInitializeToState(emit),
          changePlace: (placeId) async =>
              await _mapChangePlaceToState(emit, placeId));
    });
  }

  FutureOr<void> _mapInitializeToState(Emitter<HomeBlocState> emit) async {
    emit(const HomeBlocState.loading());
    try {
      final places = await _repository.getPlacesId();
      if (places.isNotEmpty) {
        emit(HomeBlocState.loaded(places.last));
      } else {
        emit(HomeBlocState.error(AppError('No places')));
      }
    } catch (e) {
      if (e is DioError) {
        emit(HomeBlocState.error(AppError("${e.message}: ${e.type}")));
      } else {
        emit(HomeBlocState.error(AppError(e.runtimeType.toString())));
      }
    }
  }

  FutureOr<void> _mapChangePlaceToState(
      Emitter<HomeBlocState> emit, String placeId) async {
    emit(HomeBlocState.loaded(placeId));
  }
}
