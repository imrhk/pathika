import 'package:flutter/material.dart';

class DetailPageAppBar extends StatelessWidget {
  final double height;
  final Orientation orientation;
  final String backgroundImageUrl;

  const DetailPageAppBar({Key key, this.height, this.orientation, this.backgroundImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: height * 0.5,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          child: Text(
            'Buenos Aires',
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
                  image: AssetImage(backgroundImageUrl),
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
      ),
    );
  }
}
