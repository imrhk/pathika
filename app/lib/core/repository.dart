import 'dart:convert';
import 'dart:io' as IO;
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart' as UIO;

import 'package:path_provider/path_provider.dart';

const int DEFAULT_CACHE_DURATION_IN_MINUTES = 0;

class Repository {
  static Future<String> getResponse({
    UIO.HttpClient httpClient,
    String url,
    Duration cacheTime = const Duration(),
  }) async {
    if (kIsWeb || kDebugMode) {
       return await _getResponseForWeb(
        httpClient: httpClient, url: url);
    } else {
      return _getResponseForMobile(
          httpClient: httpClient, cacheTime: cacheTime, url: url);
    }
  }

  static Future<String> _getResponseForWeb({
    UIO.HttpClient httpClient,
    String url, }) async {
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == UIO.HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        return json;
      } else {
        print(
            'Error getting a response: Http status ${response.statusCode} for $url');
      }
    } catch (exception) {
      print('Failed getting a response. Exception: $exception for url: $url');
    }
    return null;
  }

  static Future<String> _getResponseForMobile({
    UIO.HttpClient httpClient,
    String url,
    Duration cacheTime = const Duration(),
  }) async {
    final IO.Directory cacheDirectory = await getTemporaryDirectory();
    final IO.File cacheFile = IO.File('${cacheDirectory.path}/${url.hashCode}.txt');
    if (cacheTime.inSeconds > 0) {
      bool isCacheExists = await cacheFile.exists();
      if (isCacheExists) {
        try {
          DateTime lastModified = await cacheFile.lastModified();
          if (lastModified.difference(DateTime.now()).inMinutes.abs() <
              cacheTime.inMinutes) {
            String content = await cacheFile.readAsString();
            return content;
          }
        } catch (onError) {}
      }
    }
    String json = await _getResponseForWeb(
        httpClient: httpClient, url: url);
    if (json != null) {
      await cacheFile.writeAsString(json);
      return json;
    } 
    return null;
  }
}
