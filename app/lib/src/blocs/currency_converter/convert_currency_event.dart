import '../page_fetch/page_fetch_event.dart';

class ConvertCurrencyEvent extends PageFetchEvent {
  final String? language; // 2-letter e.g. 'en'
  final String? from;
  final String to;

  const ConvertCurrencyEvent({
    this.language,
    this.from,
    required this.to,
  }) : assert(language != null || from != null,
            'either language or from is required');

  @override
  List<Object?> get props => [language, from, to];
}
