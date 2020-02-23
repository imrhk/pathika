import 'package:flutter/material.dart';
import 'package:pathika/food/food_item_card.dart';
import 'package:pathika/food/food_item_details.dart';
import 'package:pathika/food/food_items_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/info_card.dart';

class FoodItemsListCard extends StatelessWidget {
  final bool useColorsOnCard;
  FoodItemsListCard({
    Key key,
    @required this.useColorsOnCard,
  })  : assert(useColorsOnCard != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FoodItemsList>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container();
        } else {
          return InfoCard(
            color: useColorsOnCard ? Colors.teal : null,
            heading: 'Food',
            body: _FoodItemsListCardInternal(
              useColorsOnCard: useColorsOnCard,
              items: snapshot.data.items,
            ),
          );
        }
      },
      initialData: FoodItemsList.empty(),
      future: _getData(context),
    );
  }

  Future<FoodItemsList> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/food.json")
        .then((source) => Future.value(FoodItemsList.fromJson(source)));
  }
}

class _FoodItemsListCardInternal extends StatefulWidget {
  final List<FoodItemDetails> items;
  final bool useColorsOnCard;

  const _FoodItemsListCardInternal({Key key, this.items, this.useColorsOnCard})
      : super(key: key);

  @override
  __FoodItemsListCardInternalState createState() =>
      __FoodItemsListCardInternalState();
}

class __FoodItemsListCardInternalState
    extends State<_FoodItemsListCardInternal> {
  List<FoodItemDetails> _filteredItems;
  bool showVegOnly = true;

  @override
  void initState() {
    _filteredItems = []..addAll(widget.items);
    _getFilterValue();
    super.initState();
  }

  Future _getFilterValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool filterValue = true;
    if (prefs.containsKey('FOOD_VEG_NON_VEG_FILTER')) {
      filterValue = prefs.getBool('FOOD_VEG_NON_VEG_FILTER');
    }
    if (filterValue != showVegOnly) {
      setState(() {
        showVegOnly = filterValue;
        if (showVegOnly) {
          _filteredItems = widget.items
              .where((element) => element.isNonVeg == false)
              .toList();
        } else {
          _filteredItems = []..addAll(widget.items);
        }
      });
    }
    return Future.value();
  }

  Future _toggleFilterValue() async {
    setState(() {
      showVegOnly = !showVegOnly;
      if (showVegOnly) {
          _filteredItems = widget.items
              .where((element) => element.isNonVeg == false)
              .toList();
        } else {
          _filteredItems = []..addAll(widget.items);
        }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('FOOD_VEG_NON_VEG_FILTER', showVegOnly);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return FoodItemCard(
                label: item.label,
                photoUrl: item.photo,
                isVeg: item.isVeg,
                isNonVeg: item.isNonVeg,
                licence: item.licence,
                attributionUrl: item.attributionUrl,
                photoBy: item.photoBy,
                cardColor: Theme.of(context).brightness == Brightness.dark ||
                        widget.useColorsOnCard
                    ? Colors.transparent
                    : null,
              );
            },
            itemCount: _filteredItems.length,
          ),
        ),
        ButtonBar(
          children: <Widget>[
            Text('Show Veg Only'),
            Switch(
              value: showVegOnly,
              onChanged: (_) => _toggleFilterValue(),
            ),
          ],
        ),
      ],
    );
  }
}
