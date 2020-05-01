import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';

class CurrentTimeCard extends StatelessWidget implements Details<int> {
  final bool useColorsOnCard;
  final int timezoneOffsetInMinute;
  CurrentTimeCard({
    Key key,
    @required this.useColorsOnCard,
    this.timezoneOffsetInMinute = 0,
  })  : assert(useColorsOnCard != null),
        super(key: key);

  int get details => timezoneOffsetInMinute;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Duration>(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          final time = DateTime.now().subtract(snapshot.data);
          final formattedTime = DateFormat.jm().format(time);
          final suffix = snapshot.data.isNegative
              ? BlocProvider.of<LocalizationBloc>(context)
                  .localize('_ahead', 'ahead')
              : BlocProvider.of<LocalizationBloc>(context)
                  .localize('_behind', 'behind');
          final hours = BlocProvider.of<LocalizationBloc>(context)
                .localize('_hours', 'hours');
          return InfoCard(
            color: useColorsOnCard ? Colors.lightGreen : null,
            heading: BlocProvider.of<LocalizationBloc>(context)
                .localize('current_time', 'Current Time'),
            title: formattedTime,
            subtitle:  snapshot.data.inSeconds == 0 ? "" : '${getTimeFromDuration(snapshot.data)} $hours $suffix',
          );
        }
      },
      initialData: Duration(),
      future: _getData(context),
    );
  }

  Future<Duration> _getData(BuildContext context) async {
    final currentTimeZoneOffset = DateTime.now().timeZoneOffset;
    final Duration targetTimeZoneOffset =
        Duration(minutes: timezoneOffsetInMinute);
    final difference = currentTimeZoneOffset - targetTimeZoneOffset;
    return Future.value(difference);
  }

  String getTimeFromDuration(Duration duration) {
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60).abs())}';
  }

  String twoDigits(int n) {
    print(n);
    if (n >= 10 || n <= -10) return "${n.abs()}";
    if(n > 0) return "0$n";
    else if(n == 0) return "00";
    else return "0${n.abs()}";
  }
}
