import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pathikagoogleplacestool/secrets.dart';

import 'input.dart';
import 'models.dart';

void main() => runApp(GooglePlacesToolApp());

final client = http.Client();

class GooglePlacesToolApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.blueAccent,
      ),
      home: TouristAttractionsList(),
      routes: {
        'search': (_) => PlaceForm(),
        'places-result': (_) => PlacesList(),
        'place-photos-result': (_) => PlacePhotosList(),
      },
    );
  }
}

class TouristAttractionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pathika Places Tool'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.of(context).pushNamed('search'),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) => ListTile(
          title: Text(places[index]),
          onTap: () {
            Navigator.of(context)
                .pushNamed('places-result', arguments: places[index]);
          },
        ),
        itemCount: places.length,
      ),
    );
  }
}

class PlacesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String query = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(query),
      ),
      body: FutureBuilder<PlaceSearchResponse>(
        future: _getData(query),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          } else {
            List<Place> places = snapshot.data.candidates;
            return ListView.builder(
              itemBuilder: (ctx, index) {
                Place place = places[index];
                return ListTile(
                  key: ValueKey(place.placeId),
                  title: Text(place.name),
                  subtitle: Text(place.formattedAddress),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('place-photos-result', arguments: place);
                  },
                );
              },
              itemCount: places.length,
            );
          }
        },
      ),
    );
  }

  Future<PlaceSearchResponse> _getData(String query) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=$API_KEY&input=$query&fields=photos,formatted_address,name,place_id&inputtype=textquery";
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return PlaceSearchResponse.fromJson(json.decode(response.body));
    } else {
      print('response: ${response.statusCode}');
    }
    return null;
  }
}

class PlacePhotosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Place place = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: FutureBuilder<PlacePhotosResponse>(
        future: _getImages(place, context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          } else {
            List<Photos> photos = snapshot.data.result.photos;
            if(photos == null) {
              return Center(
                child: Text('No Image'),
              );
            }
            return ListView.separated(
              itemBuilder: (ctx, index) {
                Photos photo = photos[index];
                return FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    width: photo.width.toDouble(),
                    height: photo.height.toDouble(),
                    child: PhotoWidget(place.name, place.placeId, photo),
                  ),
                );
              },
              itemCount: photos.length,
              separatorBuilder: (ctx, index) {
                return SizedBox(height: 10);
              },
            );
          }
        },
      ),
    );
  }

  Future<PlacePhotosResponse> _getImages(
      Place place, BuildContext context) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?key=$API_KEY&place_id=${place.placeId}&fields=photo";
    final response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      return PlacePhotosResponse.fromJson(json.decode(response.body));
    } else {
      print('response: ${response.statusCode}');
    }
    return null;
  }
}

class PhotoWidget extends StatefulWidget {
  String placeName;
  String placeId;
  Photos photo;

  PhotoWidget(this.placeName, this.placeId, this.photo);

  @override
  _PhotoWidgetState createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> with AutomaticKeepAliveClientMixin<PhotoWidget>{
  String finalPhotoUrl;



  @override
  void initState() {
    String photoUrl =
        "https://maps.googleapis.com/maps/api/place/photo?key=$API_KEY&photoreference=${widget.photo.photoReference}&maxwidth=900";
    _getUrl(photoUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(finalPhotoUrl == null) {
      return Center(
        child: Container(
            width: 40, height: 40, child: CircularProgressIndicator()),
      );
    }
    else {
      return InkWell(
        child: Image.network(
          finalPhotoUrl,
          fit: BoxFit.fitWidth,
        ),
        onTap: () {
          Map map = {
            "name": widget.placeName,
            "description": "",
            "photos": finalPhotoUrl,
            "html_attributions": widget.photo.htmlAttributions,
            "place_id": widget.placeId,
          };
          print(json.encode(map).toString());
        },
      );
    }
  }

  Future<Null> _getUrl(String url) async {
    final request = new Request('HEAD', Uri.parse(url))
      ..followRedirects = false;
    final response = await client.send(request);
    if (response.statusCode == 302) {
      return _getUrl(response.headers["location"]);
    }

    setState(() {
      finalPhotoUrl = url;
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class PlaceForm extends StatefulWidget {
  @override
  _PlaceFormState createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(hintText: 'Enter Place Name'),
                controller: _textEditingController,
              ),
            ),
            SizedBox(height: 10),
            MaterialButton(
              color: Theme.of(context).accentColor,
              child: Text('Submit'),
              onPressed: () {
                print(_textEditingController.text);
                if (_textEditingController.text.length > 3)
                  Navigator.of(context).pushNamed('places-result',
                      arguments: _textEditingController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
