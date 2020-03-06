import 'package:equatable/equatable.dart';

abstract class LocalizationEvent extends Equatable {
  final String locale;

  LocalizationEvent(this.locale);

  @override
  List<Object> get props => [locale];
}

class FetchLocalization extends LocalizationEvent {
  FetchLocalization(String locale) : super(locale); 
}

class ChangeLocalization extends LocalizationEvent {
  ChangeLocalization(String locale) : super(locale);
}