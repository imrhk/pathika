import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

const int DEFAULT_CACHE_DURATION_IN_MINUTES = 0;

class Repository {
  static Future<String> getResponse({
    HttpClient httpClient,
    String url,
    Duration cacheTime = const Duration(),
  }) async {
    final Directory cacheDirectory = await getTemporaryDirectory();
    final File cacheFile = File('${cacheDirectory.path}/${url.hashCode}.txt');
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
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        await cacheFile.writeAsString(json);
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
}
