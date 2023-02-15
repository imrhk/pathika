import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

import '../../core/app_error.dart';
import 'page_fetch_event.dart';
import 'page_fetch_state.dart';

abstract class PageFetchBloc<S extends PageFetchEvent, T>
    extends Bloc<S, PageFetchState<T>> {
  final Logger? logger;

  PageFetchBloc([this.logger]) : super(const PageFetchState.uninitialized()) {
    on<S>(
      (event, emit) async {
        emit(const PageFetchState.loading());
        try {
          final result = await fetchPage(event);
          emit(PageFetchState.loaded(result));
        } catch (e) {
          if (e is Error) {
            emit(PageFetchState.error(e));
          } else {
            emit(PageFetchState.error(AppError(e.toString())));
          }
        }
      },
    );
  }

  Future<T> fetchPage(S event);
}
