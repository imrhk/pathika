import 'package:equatable/equatable.dart';

abstract class LocalizationEvent extends Equatable {
  final String locale;

  const LocalizationEvent(this.locale);

  @override
  List<Object> get props => [locale];
}

class FetchLocalization extends LocalizationEvent {
  const FetchLocalization(String locale) : super(locale);
}

class ChangeLocalization extends LocalizationEvent {
  const ChangeLocalization(String locale) : super(locale);
}
