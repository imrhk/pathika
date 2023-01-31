import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart' as uio;

import 'package:path_provider/path_provider.dart';

const int defaultCacheDurationInMinutes = 0;

class Repository {
  static Future<String?> getResponse({
    required uio.HttpClient httpClient,
    required String url,
    Duration cacheTime = const Duration(),
  }) async {
    if (kIsWeb || kDebugMode) {
      return await _getResponseForWeb(httpClient: httpClient, url: url);
    } else {
      return _getResponseForMobile(
          httpClient: httpClient, cacheTime: cacheTime, url: url);
    }
  }

  static Future<String?> _getResponseForWeb({
    required uio.HttpClient httpClient,
    required String url,
  }) async {
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == uio.HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        return json;
      } else {
        if (kDebugMode) {
          print(
              'Error getting a response: Http status ${response.statusCode} for $url');
        }
      }
    } catch (exception) {
      if (kDebugMode) {
        print('Failed getting a response. Exception: $exception for url: $url');
      }
    }
    return null;
  }

  static Future<String?> _getResponseForMobile({
    required uio.HttpClient httpClient,
    required String url,
    Duration cacheTime = const Duration(),
  }) async {
    final io.Directory cacheDirectory = await getTemporaryDirectory();
    final io.File cacheFile =
        io.File('${cacheDirectory.path}/${url.hashCode}.txt');
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
        } catch (_) {}
      }
    }
    try {
      String? json = await _getResponseForWeb(httpClient: httpClient, url: url);
      if (json != null) {
        await cacheFile.writeAsString(json);
        return json;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
