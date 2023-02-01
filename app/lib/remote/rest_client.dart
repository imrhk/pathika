import 'package:dio/dio.dart';
import '../common/constants.dart';
import 'package:retrofit/retrofit.dart';

import '../places/model/place_info.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "$baseUrl/assets/json/$apiVersion/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/places_{currentLanguage}.json")
  Future<List<PlaceInfo>> getPlaces(@Path() String currentLanguage);
}

abstract class RemoteService {
  Future<List<PlaceInfo>> getPlaces(String currentLanguage);
}
