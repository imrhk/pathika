import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pathika/common/constants.dart';

import './material_card.dart';
import '../core/utility.dart';
import 'shimmer_text.dart';

class InfoCard extends StatelessWidget {
  final MaterialColor? color;
  final Color? bgColor;
  final String? heading;
  final String title;
  final String subtitle;
  final String symbol;
  final Widget? footer;
  final Widget? body;
  final EdgeInsets? padding;
  final bool isAudiable;
  const InfoCard({
    super.key,
    required this.color,
    this.bgColor,
    this.heading,
    this.title = '',
    this.subtitle = '',
    this.symbol = '',
    this.footer,
    this.body,
    this.padding,
    this.isAudiable = false,
  });
  @override
  Widget build(BuildContext context) {
    final shimmerGradient = getShimmerGradient(context);
    return MaterialCard(
      clipBehavior: Clip.antiAlias,
      color: getColorsOnCard(context) ? color : null,
      shadowColor:
          getColorsOnCard(context) ? color : const Color.fromARGB(255, 0, 0, 0),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: bgColor == null && getColorsOnCard(context) && color != null
              ? LinearGradient(
                  colors: [
                    color!.shade500.withOpacity(1),
                    color!.shade500.withOpacity(0.67),
                  ],
                  end: FractionalOffset.topCenter,
                  begin: FractionalOffset.bottomCenter,
                )
              : null,
        ),
        child: Stack(
          children: [
            if (isAudiable)
              Align(
                alignment: Alignment.topRight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    hoverColor: bgColor ?? color,
                    splashColor: bgColor ?? color,
                    focusColor: bgColor ?? color,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(Icons.volume_up),
                    ),
                    onTap: () {
                      if (kDebugMode) {
                        print('tapped');
                      }
                    },
                  ),
                ),
              ),
            if (symbol != "")
              Align(
                heightFactor: 1.5,
                alignment: Alignment.bottomLeft,
                child: Text(
                  symbol,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                heading != null
                    ? Text(
                        heading ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )
                    : Container(),
                SizedBox(
                    height: heading == null ? 0 : (body == null ? 30 : 10)),
                if (body == null)
                  OptionalShimmer(
                    gradient: shimmerGradient,
                    child: Text(
                      shimmerGradient == null
                          ? title
                          : title.replaceAll(regexEmojies, ''),
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                if (body == null)
                  Text(
                    subtitle,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                if (body != null) body!,
                footer == null
                    ? Container()
                    : const Divider(
                        thickness: 2,
                      ),
                footer ?? Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
