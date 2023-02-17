import 'package:flutter/material.dart';
import 'package:pathika/src/constants/regex_constants.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../../../models/place_models/place_models.dart';
import '../../widgets/info_card.dart';

class SportsCard extends StatelessWidget implements Details<SportsDetails> {
  @override
  final SportsDetails details;
  const SportsCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    final footer = context.keepEmojiInText
        ? details.footer
        : details.footer?.replaceAll(regexEmojies, '');
    return InfoCard(
      color: Colors.lightBlue,
      heading: context.l10n.most_popular_sports,
      title: details.title ?? '',
      footer: Text(footer ?? ''),
    );
  }
}
