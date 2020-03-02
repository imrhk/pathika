import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';
import '../common/material_card.dart';
import '../core/repository.dart';
import 'app_language.dart';

class SelectLanguagePage extends StatefulWidget {
  final HttpClient httpClient;

  const SelectLanguagePage({Key key, this.httpClient}) : super(key: key);
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

const APP_LANGUAGE = 'app_language';

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  bool appLanguageChecked = false;
  String appLangauge;

  @override
  void initState() {
    super.initState();
    _checkForAppLanguage();
  }

  _checkForAppLanguage() async {
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.containsKey(APP_LANGUAGE)) {
      appLangauge = sharedPref.getString(APP_LANGUAGE);
      Navigator.of(context).pop(appLangauge);
    } else {
      setState(() {
        appLanguageChecked = true;
      });
    }
  }

  _saveAppLanguage(String id) async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(APP_LANGUAGE, id);
    Navigator.of(context).pop(id);
  }

  @override
  Widget build(BuildContext context) {
    if (!appLanguageChecked) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: FutureBuilder<List<AppLanguage>>(
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error. Please check your connection'),
            );
          } else if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final appLanguages = snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 225,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemBuilder: (ctx, index) {
                  final item = appLanguages[index];
                  return MaterialCard(
                    margin: EdgeInsets.all(10),
                    elevation: 6,
                    shadowColor: Color.fromARGB(item.color[0], item.color[1],
                        item.color[2], item.color[3]),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Card(
                      margin: EdgeInsets.all(0),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          final language = item.id;
                          _saveAppLanguage(language);
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.black.withAlpha(16)),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                item.name,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: Text(
                                  item.msg,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: appLanguages.length,
              ),
            );
          }
        },
        future: _getData(context),
      ),
    );
  }

  Future<List<AppLanguage>> _getData(BuildContext context) async {
    Future<String> response = kDebugMode
        ? DefaultAssetBundle.of(context)
            .loadString('assets_remote/assets/json/v1/languages.json')
        : Repository.getResponse(
            httpClient: widget.httpClient,
            url: '$BASE_URL/assets/json/$API_VERSION/languages.json',
            cacheTime: Duration(days: 1),
          );

    return response.then(
        (source) => Future.value(AppLanguage.fromList(json.decode(source))));
  }
}
