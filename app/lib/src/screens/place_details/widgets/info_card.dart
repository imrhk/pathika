import 'package:flutter/material.dart';

import '../../../constants/regex_constants.dart';
import '../../../extensions/context_extensions.dart';
import '../../../widgets/material_card.dart';
import '../../../widgets/optional_shimmer.dart';

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
    final shimmerGradient = context.textGradient;
    return MaterialCard(
      clipBehavior: Clip.antiAlias,
      color: context.showColorsOnCards ? color : null,
      shadowColor: context.showColorsOnCards
          ? color
          : const Color.fromARGB(255, 0, 0, 0),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      elevation: 8,
      shape: context.theme.cardTheme.shape,
      child: Container(
        width: double.infinity,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient:
              bgColor == null && context.showColorsOnCards && color != null
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
                    onTap: () {},
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
                    : const SizedBox.shrink(),
                SizedBox(
                    height: heading == null ? 0 : (body == null ? 30 : 10)),
                if (body == null)
                  OptionalShimmer(
                    gradient: shimmerGradient,
                    child: Text(
                      context.keepEmojiInText
                          ? title
                          : title.replaceAll(regexEmojies, ''),
                      textAlign: TextAlign.end,
                      style: context.theme.textTheme.headlineMedium,
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
                    ? const SizedBox.shrink()
                    : const Divider(
                        thickness: 2,
                      ),
                footer ?? const SizedBox.shrink(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
