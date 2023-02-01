import 'package:flutter/material.dart';

import 'weather_item.dart';

class WeatherDetails extends StatelessWidget {
  final List<WeatherItem> items;

  const WeatherDetails({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          final item = items[index];
          return ListTile(
            leading: Text(
              item.emoji,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            title: Text(item.name),
            subtitle: Text(item.temp),
            trailing: Text(item.duration),
          );
        },
        separatorBuilder: (ctx, index) {
          return const Divider();
        },
        itemCount: items.length);
  }
}
