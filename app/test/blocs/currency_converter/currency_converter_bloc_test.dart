import 'package:bloc_test/bloc_test.dart';
import 'package:pathika/src/blocs/currency_converter/convert_currency_event.dart';
import 'package:pathika/src/blocs/currency_converter/currency_converter_bloc.dart';
import 'package:pathika/src/blocs/page_fetch/page_fetch_state.dart';
import 'package:pathika/src/core/app_error.dart';
import 'package:pathika/src/data/remote/remote_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pathika/src/models/currency_conversion_item/currency_conversion_item.dart';
import 'package:pathika/src/models/user_country/user_country.dart';
import 'package:test/test.dart';

class MockRemoteRepository extends Mock implements RemoteRepository {}

class MockConversionItem extends Mock implements ConversionItem {}

class MockUserCountry extends Mock implements UserCountry {}

const fooUsdRate = r'''{
  "FOO_USD": 42.00
}''';

const fooEurRate = r'''{
  "FOO_EUR": 49.00
}''';

const fooInrRate = r'''{
  "FOO_INR": 32.31
}''';

const usdFooRate = r'''{
  "USD_FOO": 0.02380952381
}''';

const to = 'FOO';
const from = 'BAR';

const userCountryName = 'CountryName';
const userCountryCode = 'XYZ';

void main() {
  group('CurrencyConverterBloc', () {
    late CurrencyConverterBloc currencyConverterBloc;
    late RemoteRepository remoteRepository;
    late UserCountry userCountry;
    late ConversionItem conversionItem;
    setUp(() {
      remoteRepository = MockRemoteRepository();
      userCountry = MockUserCountry();

      when(() => remoteRepository.getUserCountry())
          .thenAnswer((_) async => userCountry);

      currencyConverterBloc = CurrencyConverterBloc(remoteRepository);
    });

    test('initial state is correct', () {
      final bloc = CurrencyConverterBloc(remoteRepository);
      // ignore: prefer_void_to_null
      expect(bloc.state, const PageFetchState<Never>.uninitialized());
    });

    group('fetch conversion', () {
      blocTest(
        'fetch when from param is not provided and user country is random',
        build: () => currencyConverterBloc,
        act: (bloc) => bloc.add(
          const ConvertCurrencyEvent(to: to, language: 'en'),
        ),
        expect: () => [
          const PageFetchState<Never>.loading(),
          const PageFetchState<ConversionItem?>.loaded(
            ConversionItem(from: 'USD', to: to, value: 42.0, quantity: 1),
          )
        ],
        setUp: () {
          when(() => userCountry.name).thenReturn(userCountryName);
          when(() => userCountry.code).thenReturn(userCountryCode);

          when(
            () => remoteRepository.getCurrencyConversionRate(any(), any()),
          ).thenAnswer((_) async => fooUsdRate);
        },
      );
    });

    blocTest(
      'fetch when from param is not provided and user country is France',
      build: () => currencyConverterBloc,
      act: (bloc) => bloc.add(
        const ConvertCurrencyEvent(to: to, language: 'fr'),
      ),
      expect: () => [
        const PageFetchState<Never>.loading(),
        const PageFetchState<ConversionItem?>.loaded(
          ConversionItem(from: 'EUR', to: to, value: 49.0, quantity: 1),
        )
      ],
      setUp: () {
        when(() => userCountry.name).thenReturn('France');
        when(() => userCountry.code).thenReturn('fr');

        when(() => remoteRepository.getUserCountry())
            .thenAnswer((_) async => userCountry);

        when(
          () => remoteRepository.getCurrencyConversionRate(any(), any()),
        ).thenAnswer((_) async => fooEurRate);
      },
    );

    blocTest(
      'fetch when from param is inr',
      build: () => currencyConverterBloc,
      act: (bloc) => bloc.add(
        const ConvertCurrencyEvent(to: to, from: "INR"),
      ),
      expect: () => [
        const PageFetchState<Never>.loading(),
        const PageFetchState<ConversionItem?>.loaded(
          ConversionItem(from: 'INR', to: to, value: 32.31, quantity: 1),
        )
      ],
      setUp: () {
        when(() => userCountry.name).thenReturn('India');
        when(() => userCountry.code).thenReturn('in');

        when(() => remoteRepository.getUserCountry())
            .thenAnswer((_) async => userCountry);

        when(
          () => remoteRepository.getCurrencyConversionRate(any(), any()),
        ).thenAnswer((_) async => fooInrRate);
      },
    );

    blocTest(
      'fetch when value is less than 1',
      build: () => currencyConverterBloc,
      act: (bloc) => bloc.add(
        const ConvertCurrencyEvent(
          to: "USD",
          from: "FOO",
        ),
      ),
      expect: () => [
        const PageFetchState<Never>.loading(),
        const PageFetchState<ConversionItem?>.loaded(
          ConversionItem(
              from: to, to: 'USD', value: 2.380952381, quantity: 100),
        )
      ],
      setUp: () {
        when(() => userCountry.name).thenReturn(userCountryName);
        when(() => userCountry.code).thenReturn(userCountryCode);

        when(
          () => remoteRepository.getCurrencyConversionRate(any(), any()),
        ).thenAnswer((_) async => usdFooRate);
      },
    );

    blocTest('throw error when user country throws exception',
        setUp: () {
          when(
            () => remoteRepository.getUserCountry(),
          ).thenAnswer((invocation) => throw Exception());
        },
        build: () => currencyConverterBloc,
        act: (bloc) => bloc,
        expect: () => [
              const PageFetchState<Never>.loading(),
              PageFetchState.error(AppError(Exception().toString()))
            ]);
  });
}
