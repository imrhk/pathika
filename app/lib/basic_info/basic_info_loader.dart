import 'package:flutter/material.dart';
import 'package:pathika/basic_info/basic_info.dart';

import 'basic_info_app_bar.dart';

class BasicInfoLoader extends StatelessWidget {
  final double height;
  final Orientation orientation;

  const BasicInfoLoader({Key key, this.height, this.orientation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BasicInfo>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                child: CircularProgressIndicator(),
              ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return 
             FlexibleSpaceBar(
              centerTitle: true,
              background: Text('Error retriving data, please try again'),
          );
        } else {
          return BasicInfoAppBar(
            height: height,
            orientation: orientation,
            basicInfo: snapshot.data,
          );
        }
      },
      future: _getData(context),
      initialData: BasicInfo.empty(),
    );
  }

  Future<BasicInfo> _getData(BuildContext context) async {
    return DefaultAssetBundle.of(context)
        .loadString("assets/data/basic_info.json")
        .then((source) => Future.value(BasicInfo.fromJson(source)));
  }
}
