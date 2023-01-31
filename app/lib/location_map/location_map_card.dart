import 'package:flutter/material.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../core/utility.dart';
import 'location_map_details.dart';

class LocationMapCard extends StatelessWidget
    implements Details<LocationMapDetails> {
  @override
  final LocationMapDetails details;
  const LocationMapCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return _LocationMapStackCardInternal(
      items: details.items,
    );
  }
}

class _LocationMapStackCardInternal extends StatefulWidget {
  final List<String> items;

  const _LocationMapStackCardInternal({
    this.items = const [],
  });

  @override
  State createState() => __LocationMapItemsStackCardInternalState();
}

class __LocationMapItemsStackCardInternalState
    extends State<_LocationMapStackCardInternal> {
  late List<String> items;

  @override
  void initState() {
    super.initState();
    items = [...widget.items];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          final removed = items.removeAt(0);
          items.add(removed);
        });
      },
      child: InfoCard(
        color: widget.getColorsOnCard(context) ? Colors.lightBlue : null,
        padding: const EdgeInsets.all(0.0),
        body: AspectRatio(
          aspectRatio: 1.72,
          child: Image.network(
            items[0],
            fit: BoxFit.fitWidth,
          ),
        ),
        isAudiable: false,
      ),
    );
  }
}
