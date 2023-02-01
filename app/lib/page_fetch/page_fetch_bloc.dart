import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

import '../core/app_error.dart';
import 'page_fetch_event.dart';
import 'page_fetch_state.dart';

abstract class PageFetchBloc<S extends PageFetchEvent, T>
    extends Bloc<S, PageFetchState<T>> {
  final Logger? logger;

  PageFetchBloc([this.logger]) : super(Uninitialized()) {
    on<S>(
      (event, emit) async {
        emit(Loading());
        try {
          final result = await fetchPage(event);
          emit(Loaded(result));
        } catch (e) {
          if (e is Error) {
            emit(LoadFailure(e));
          } else {
            emit(LoadFailure(AppError(e.toString())));
          }
        }
      },
    );
  }

  Future<T> fetchPage(S event);
}
