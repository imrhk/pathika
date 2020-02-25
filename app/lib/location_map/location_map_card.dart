import 'package:flutter/material.dart';

import '../common/info_card.dart';
import 'location_map_details.dart';

class LocationMapCard extends StatelessWidget {
  final bool useColorsOnCard;
  LocationMapCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    print('locationmapcard build called');
    return FutureBuilder<LocationMapDetails>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(height: 40);
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return _LocationMapStackCardInternal(
            useColorsOnCard: useColorsOnCard,
            items: snapshot.data.items,
          );
        }
      },
      initialData: LocationMapDetails.empty(),
      future: _getData(context),
    );
  }

  Future<LocationMapDetails> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/location_map.json")
        .then((source) => Future.value(LocationMapDetails.fromJson(source)));
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
