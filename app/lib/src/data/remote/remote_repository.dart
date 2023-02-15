import '../../models/app_language/app_language.dart';
import '../../models/place_models/place_models.dart';
import '../../models/user_country/user_country.dart';
import 'rest_client.dart';

class RemoteRepository extends RemoteService {
  final RestClient restClient;

  RemoteRepository(this.restClient);

  @override
  Future<List<PlaceInfo>> getPlaces(String currentLanguage) =>
      restClient.getPlaces(currentLanguage);

  @override
  Future<PlaceDetails> getPlaceDetails(
          String placeId, String currentLanguage) =>
      restClient.getPlaceDetails(placeId, currentLanguage);

  @override
  Future<List<String>> getPlacesId() => restClient.getPlacesId();

  @override
  Future<List<AppLanguage>> getAppLanguages() => restClient.getAppLanguages();

  @override
  Future<UserCountry> getUserCountry() => restClient.getUserCountry();

  @override
  Future<String> getCurrencyConversionRate(String from, String to) =>
      restClient.getCurrencyConversionRate(from, to);

  @override
  Future<String> getLocalization(String language) =>
      restClient.getLocalization(language);
}
