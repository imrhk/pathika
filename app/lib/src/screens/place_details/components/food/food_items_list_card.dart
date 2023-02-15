import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/adt_details.dart';
import '../../../../extensions/context_extensions.dart';
import '../../../../models/place_models/place_models.dart';
import '../../../app_settings/bloc/app_settings_bloc.dart';
import '../../../app_settings/bloc/app_settings_event.dart';
import '../../../app_settings/bloc/app_settings_state.dart';
import '../../widgets/info_card.dart';
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
      heading: context.localize('food', 'Food'),
      body: _FilteredFoodItemsList(
        items: details,
      ),
    );
  }
}

class _FilteredFoodItemsList extends StatelessWidget {
  final List<FoodItemDetails> items;

  const _FilteredFoodItemsList({
    this.items = const [],
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loaded: (value) {
            final onlyVeg = value.onlyVeg;
            final filteredItems = onlyVeg
                ? items.where((e) => e.isVeg).toList(growable: false)
                : items;

            return _FoodItemList(
              items: filteredItems,
              onlyVeg: onlyVeg,
            );
          },
        );
      },
    );
  }
}

class _FoodItemList extends StatelessWidget {
  const _FoodItemList({
    required this.items,
    required this.onlyVeg,
  });

  final List<FoodItemDetails> items;
  final bool onlyVeg;

  Future _toggleFilterValue(BuildContext context) async {
    context
        .read<AppSettingsBloc>()
        .add(const AppSettingsEvent.toggleVegPreference());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            height: 250,
            child: items.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: false,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return FoodItemCard(
                        key: ValueKey(item.label),
                        label: item.label,
                        photoUrl: item.photo,
                        isVeg: item.isVeg,
                        isNonVeg: item.isNonVeg,
                        licence: item.licence,
                        attributionUrl: item.attributionUrl,
                        photoBy: item.photoBy,
                      );
                    },
                    itemCount: items.length,
                  )
                : onlyVeg
                    ? Center(
                        child: Text(
                          context.localize('no_veg_available',
                              'Vegetarian foods are not popular here.'),
                        ),
                      )
                    : const Center(child: Text(''))),
        ButtonBar(
          children: <Widget>[
            Text(
              context.localize('veg_only', 'Show Veg Only'),
            ),
            Switch.adaptive(
              value: onlyVeg,
              onChanged: (_) => _toggleFilterValue(context),
            ),
          ],
        ),
      ],
    );
  }
}
