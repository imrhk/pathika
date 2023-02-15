import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/currency_converter/convert_currency_event.dart';
import '../../../../blocs/currency_converter/currency_converter_bloc.dart';
import '../../../../blocs/page_fetch/page_fetch_state.dart';
import '../../../../data/remote/remote_repository.dart';
import '../../../../extensions/context_extensions.dart';
import '../../../../models/currency_conversion_item/currency_conversion_item.dart';

class CurrencyValue extends StatelessWidget {
  final String to;
  final String symbol;

  const CurrencyValue({
    super.key,
    required this.to,
    required this.symbol,
  });

  //'TO' is left , 'From' is right.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrencyConverterBloc>(
      create: (context) {
        return CurrencyConverterBloc(context.read<RemoteRepository>())
          ..add(ConvertCurrencyEvent(
            language: context.currentLanguage,
            to: to,
          ));
      },
      child:
          BlocBuilder<CurrencyConverterBloc, PageFetchState<ConversionItem?>>(
        builder: (context, state) {
          return state.when(
              uninitialized: _loadingBuilder,
              loaded: _loadedBuilder,
              loading: _loadingBuilder,
              error: _errorBuilder);
        },
      ),
    );
  }

  Widget _loadingBuilder() {
    return const Text(
      ' ',
      style: TextStyle(
        fontSize: 20,
      ),
      textAlign: TextAlign.end,
    );
  }

  Widget _errorBuilder(Error error) {
    return const SizedBox.shrink();
  }

  Widget _loadedBuilder(ConversionItem? item) {
    if (item == null || item.quantity == 0) {
      return const SizedBox.shrink();
    }
    final symbolTo = NumberFormat.simpleCurrency(name: item.to);
    final symbolFrom = NumberFormat.simpleCurrency(name: item.from);
    final quantity = item.quantity;
    final valueTo = item.value * quantity;
    final valueFrom = quantity;
    final currencySymbolTextTo =
        symbolTo.currencySymbol == symbolFrom.currencySymbol
            ? item.to
            : symbolTo.currencySymbol;
    final currencySymbolTextFrom =
        symbolTo.currencySymbol == symbolFrom.currencySymbol
            ? item.from
            : symbolFrom.currencySymbol;

    return Text(
      '$currencySymbolTextFrom ${valueFrom.toStringAsFixed(2)} = $currencySymbolTextTo ${valueTo.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 20,
      ),
      textAlign: TextAlign.end,
    );
  }
}
