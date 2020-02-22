import 'package:flutter/material.dart';

import 'package:pathika/climate/weather_item.dart';

class WeatherDetails extends StatelessWidget {
  final List<WeatherItem> items;
  WeatherDetails({
    Key key,
    @required this.items,
  })  : assert(items != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, index) {
          final item = items[index];
          return ListTile(
            leading: Text(
              item.emoji,
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            title: Text(item.name),
            subtitle: Text(item.temp),
            trailing: Text(item.duration),
          );
        },
        separatorBuilder: (ctx, index) {
          return Container(child: Divider(),);
        },
        itemCount: items.length);
  }
}
