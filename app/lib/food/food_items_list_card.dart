import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart' show Platform;

import '../common/info_card.dart';
import '../core/adt_details.dart';
import '../localization/localization.dart';
import '../models/place_models.dart';
import 'food_item_card.dart';

class FoodItemsListCard extends StatelessWidget
    implements Details<List<FoodItemDetails>> {
  @override
  final List<FoodItemDetails> details;
  const FoodItemsListCard({
    super.key,
    required this.details,
  });
  @override
  Widget build(BuildContext context) {
    return InfoCard(
      color: Colors.teal,
      heading:
          BlocProvider.of<LocalizationBloc>(context).localize('food', 'Food'),
      body: _FoodItemsListCardInternal(
        items: details,
      ),
    );
  }
}

class _FoodItemsListCardInternal extends StatefulWidget {
  final List<FoodItemDetails> items;

  const _FoodItemsListCardInternal({
    this.items = const [],
  });

  @override
  __FoodItemsListCardInternalState createState() =>
      __FoodItemsListCardInternalState();
}

class __FoodItemsListCardInternalState
    extends State<_FoodItemsListCardInternal> {
  late List<FoodItemDetails> _filteredItems;
  bool showVegOnly = true;

  @override
  void initState() {
    _filteredItems = [...widget.items];
    _setFilteredItems();
    super.initState();
  }

  Future _setFilteredItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool filterValue = prefs.getBool('FOOD_VEG_NON_VEG_FILTER') ?? false;
    setState(() {
      showVegOnly = filterValue;
      if (showVegOnly) {
        _filteredItems =
            widget.items.where((element) => element.isVeg).toList();
      } else {
        _filteredItems = [...widget.items];
      }
    });
    return Future.value();
  }

  Future _toggleFilterValue() async {
    setState(() {
      showVegOnly = !showVegOnly;
      if (showVegOnly) {
        _filteredItems =
            widget.items.where((element) => element.isVeg).toList();
      } else {
        _filteredItems = [...widget.items];
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('FOOD_VEG_NON_VEG_FILTER', showVegOnly);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            height: 250,
            child: _filteredItems.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
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
                      );
                    },
                    itemCount: _filteredItems.length,
                  )
                : showVegOnly
                    ? Center(
                        child: Text(
                          BlocProvider.of<LocalizationBloc>(context).localize(
                              'no_veg_available',
                              'Vegetarian foods are not popular here.'),
                        ),
                      )
                    : const Center(child: Text(''))),
        ButtonBar(
          children: <Widget>[
            Text(
              BlocProvider.of<LocalizationBloc>(context)
                  .localize('veg_only', 'Show Veg Only'),
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

  Widget getPlatformSwitch(
      {required bool value, ValueChanged<bool>? onChanged}) {
    return Platform.isIOS
        ? CupertinoSwitch(value: value, onChanged: onChanged)
        : Switch(value: value, onChanged: onChanged);
  }
}
