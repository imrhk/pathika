import 'package:flutter/material.dart';

import 'basic_info.dart';

class BasicInfoAppBar extends StatelessWidget {
  final double height;
  final Orientation orientation;
  final BasicInfo basicInfo;
  const BasicInfoAppBar(
      {Key key, this.height, this.orientation, this.basicInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      title: Container(
        child: Text(
          basicInfo.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
      background: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(basicInfo.backgroundImage),
                fit: orientation == Orientation.portrait
                    ? BoxFit.fitHeight
                    : BoxFit.fitWidth,
              ),
            ),
          ),
         
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.0)
                  ],
                  end: FractionalOffset.topCenter,
                  begin: FractionalOffset.bottomCenter,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
