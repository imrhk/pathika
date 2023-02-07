import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../common/constants.dart';
import '../models/app_language.dart';
import '../models/place_models.dart';
import '../models/user_country.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "$baseUrl/assets/json/$apiVersion/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("places_{current_language}.json")
  Future<List<PlaceInfo>> getPlaces(
      @Path("current_language") String currentLanguage);

  @GET("{place_id}/details_{current_language}.json")
  Future<PlaceDetails> getPlaceDetails(@Path("place_id") String placeId,
      @Path("current_language") String currentLanguage);

  @GET("places.json")
  Future<List<String>> getPlacesId();

  @GET("languages.json")
  Future<List<AppLanguage>> getAppLanguages();

  @GET("http://ip-api.com/json/")
  Future<UserCountry> getUserCountry();

  @GET("$apiUrl/convertCurrency?from={from}&to={to}")
  Future<String> getCurrencyConversionRate(
      @Path("from") String from, @Path("to") String to);

  @GET("localization_{language}.json")
  Future<String> getLocalization(@Path("language") String language);
}

abstract class RemoteService {
  Future<List<PlaceInfo>> getPlaces(String currentLanguage);
  Future<PlaceDetails> getPlaceDetails(String placeId, String currentLanguage);
  Future<List<String>> getPlacesId();
  Future<List<AppLanguage>> getAppLanguages();
  Future<UserCountry> getUserCountry();
  Future<String> getCurrencyConversionRate(String from, String to);

  Future<String> getLocalization(String language);
}
