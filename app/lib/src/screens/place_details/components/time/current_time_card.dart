import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../widgets/info_card.dart';

class CurrentTimeCard extends StatelessWidget implements Details<int> {
  final int timezoneOffsetInMinute;
  const CurrentTimeCard({
    super.key,
    this.timezoneOffsetInMinute = 0,
  });

  @override
  int get details => timezoneOffsetInMinute;

  @override
  Widget build(BuildContext context) {
    final difference = _getDifference();
    final time = DateTime.now().subtract(difference);
    final formattedTime = DateFormat.jm().format(time);
    final suffix = difference.isNegative
        ? context.localize('_ahead', 'ahead')
        : context.localize('_behind', 'behind');
    final hours = context.localize('_hours', 'hours');
    return InfoCard(
      color: Colors.lightGreen,
      heading: context.localize('current_time', 'Current Time'),
      title: formattedTime,
      subtitle: difference.inSeconds == 0
          ? ""
          : '${_getTimeFromDuration(difference)} $hours $suffix',
    );
  }

  Duration _getDifference() {
    final currentTimeZoneOffset = DateTime.now().timeZoneOffset;
    final Duration targetTimeZoneOffset =
        Duration(minutes: timezoneOffsetInMinute);
    final difference = currentTimeZoneOffset - targetTimeZoneOffset;
    return difference;
  }

  String _getTimeFromDuration(Duration duration) {
    return '${_twoDigits(duration.inHours)}:${_twoDigits(duration.inMinutes.remainder(60).abs())}';
  }

  String _twoDigits(int n) {
    if (n >= 10 || n <= -10) return "${n.abs()}";
    if (n > 0) {
      return "0$n";
    } else if (n == 0) {
      return "00";
    } else {
      return "0${n.abs()}";
    }
  }
}
