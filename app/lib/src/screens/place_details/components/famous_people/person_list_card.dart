import 'package:flutter/material.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../../../models/place_models/place_models.dart';
import '../../widgets/info_card.dart';
import 'person_tile.dart';

class PersonListCard extends StatelessWidget
    implements Details<List<PersonDetails>> {
  @override
  final List<PersonDetails> details;
  const PersonListCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.cyan,
      heading: context.l10n.famous_people,
      body: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = details[index];
          return PersonTile(
            name: item.name,
            avatarUrl: item.avatarUrl,
            work: item.work,
            place: item.place,
            attributionUrl: item.attributionUrl,
            licence: item.licence,
            photoBy: item.photoBy,
          );
        },
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Divider(
            thickness: 2,
          ),
        ),
        itemCount: details.length,
        shrinkWrap: true,
      ),
    );
  }
}
