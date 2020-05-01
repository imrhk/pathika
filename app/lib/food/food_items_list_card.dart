import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import 'food_item_card.dart';
import 'food_item_details.dart';
import 'food_items_list.dart';

class FoodItemsListCard extends StatelessWidget implements Details<FoodItemsList> {
  final bool useColorsOnCard;
  final FoodItemsList details;
  FoodItemsListCard({
    Key key,
    @required this.useColorsOnCard,
    @required this.details,
  })  : assert(useColorsOnCard != null && details != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: useColorsOnCard ? Colors.teal : null,
      heading: BlocProvider.of<LocalizationBloc>(context).localize('food', 'Food'),
      body: _FoodItemsListCardInternal(
        useColorsOnCard: useColorsOnCard,
        items: details.items,
      ),
    );
  }
}

class _FoodItemsListCardInternal extends StatefulWidget {
  final List<FoodItemDetails> items;
  final bool useColorsOnCard;

  const _FoodItemsListCardInternal({Key key, this.items, this.useColorsOnCard}) : super(key: key);

  @override
  __FoodItemsListCardInternalState createState() => __FoodItemsListCardInternalState();
}

class __FoodItemsListCardInternalState extends State<_FoodItemsListCardInternal> {
  List<FoodItemDetails> _filteredItems;
  bool showVegOnly = true;

  @override
  void initState() {
    _filteredItems = []..addAll(widget.items);
    _setFilteredItems();
    super.initState();
  }

  Future _setFilteredItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool filterValue = true;
    if (prefs.containsKey('FOOD_VEG_NON_VEG_FILTER')) {
      filterValue = prefs.getBool('FOOD_VEG_NON_VEG_FILTER');
    }
    setState(() {
      showVegOnly = filterValue;
      if (showVegOnly) {
        _filteredItems = widget.items.where((element) => element.isVeg).toList();
      } else {
        _filteredItems = []..addAll(widget.items);
      }
    });
    return Future.value();
  }

  Future _toggleFilterValue() async {
    setState(() {
      showVegOnly = !showVegOnly;
      if (showVegOnly) {
        _filteredItems = widget.items.where((element) => element.isVeg).toList();
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
            child: _filteredItems.length != 0
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: false,
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
                        cardColor: Theme.of(context).brightness == Brightness.dark || widget.useColorsOnCard ? Colors.transparent : null,
                      );
                    },
                    itemCount: _filteredItems.length,
                  )
                : showVegOnly
                    ? Center(
                        child: Text(
                          BlocProvider.of<LocalizationBloc>(context).localize('no_veg_available', 'Vegetarian foods are not popular here.'),
                        ),
                      )
                    : Center(child: Text(''))),
        ButtonBar(
          children: <Widget>[
            Text(
              BlocProvider.of<LocalizationBloc>(context).localize('veg_only', 'Show Veg Only'),
            ),
            getPlatformSwitch(
              value: showVegOnly,
              onChanged: (_) => _toggleFilterValue(),
            ),
          ],
        ),
      ],
    );
  }

  Widget getPlatformSwitch({bool value, Function onChanged}) {
    return Platform.isIOS ? CupertinoSwitch(value: value, onChanged: onChanged) : Switch(value: value, onChanged: onChanged);
  }
}
