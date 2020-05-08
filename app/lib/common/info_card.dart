import 'package:flutter/material.dart';
import './material_card.dart';

class InfoCard extends StatelessWidget {
  final MaterialColor color;
  final Color bgColor;
  final String heading;
  final String title;
  final String subtitle;
  final String symbol;
  final Widget footer;
  final Widget body;
  final EdgeInsets padding;
  final bool isAudiable;
  const InfoCard({
    Key key,
    this.color,
    this.bgColor,
    this.heading,
    this.title = '',
    this.subtitle = '',
    this.symbol = '',
    this.footer,
    this.body,
    this.padding,
    this.isAudiable = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      clipBehavior: Clip.antiAlias,
      color: bgColor,
      shadowColor: color != null ? color : Color.fromARGB(255, 0, 0, 0),
      margin: EdgeInsets.fromLTRB(12, 12, 12, 6),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding: padding == null
            ? EdgeInsets.symmetric(vertical: 16, horizontal: 16)
            : padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: bgColor == null && color != null
              ? LinearGradient(
                  colors: [
                    color.shade500.withOpacity(1),
                    color.shade500.withOpacity(0.67),
                  ],
                  end: FractionalOffset.topCenter,
                  begin: FractionalOffset.bottomCenter,
                )
              : null,
        ),
        child: Stack(
          children: [
            if (isAudiable)
              Align(
                alignment: Alignment.topRight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    hoverColor: bgColor ?? color,
                    splashColor: bgColor ?? color,
                    focusColor: bgColor ?? color,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.volume_up),
                    ),
                    onTap: () {
                      print('tapped');
                    },
                  ),
                ),
              ),
            if (symbol != null && symbol != "")
              Align(
                heightFactor: 1.5,
                alignment: Alignment.bottomLeft,
                child: Text(
                  symbol,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                heading != null
                    ? Text(
                        heading,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    : Container(),
                SizedBox(
                    height: heading == null ? 0 : (body == null ? 30 : 10)),
                if (body == null)
                  Text(
                    title,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                if (body == null)
                  Text(
                    subtitle,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                if (body != null) body,
                footer == null
                    ? Container()
                    : Divider(
                        thickness: 2,
                      ),
                footer == null ? Container() : footer,
              ],
            )
          ],
        ),
      ),
    );
  }
}
