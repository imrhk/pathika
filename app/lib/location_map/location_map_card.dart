import 'package:flutter/material.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import 'location_map_details.dart';

class LocationMapCard extends StatelessWidget implements Details<LocationMapDetails>{
  final bool useColorsOnCard;
  final LocationMapDetails details;
  LocationMapCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return _LocationMapStackCardInternal(
      useColorsOnCard: useColorsOnCard,
      items: details.items,
    );
  }
}

class _LocationMapStackCardInternal extends StatefulWidget {
  final List<String> items;
  final bool useColorsOnCard;

  const _LocationMapStackCardInternal(
      {Key key, this.items, this.useColorsOnCard})
      : super(key: key);

  @override
  __LocationMapItemsStackCardInternalState createState() =>
      __LocationMapItemsStackCardInternalState(items);
}

class __LocationMapItemsStackCardInternalState
    extends State<_LocationMapStackCardInternal> {
  List<String> items;
  __LocationMapItemsStackCardInternalState(List<String> items)
      : this.items = []..addAll(items);

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
        color: widget.useColorsOnCard ? Colors.lightBlue : null,
        padding: EdgeInsets.all(0.0),
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
