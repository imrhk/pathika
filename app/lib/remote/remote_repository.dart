import '../places/model/place_info.dart';
import 'rest_client.dart';

class RemoteRepository extends RemoteService {
  final RestClient restClient;

  RemoteRepository(this.restClient);

  @override
  Future<List<PlaceInfo>> getPlaces(String currentLanguage) =>
      restClient.getPlaces(currentLanguage);
}
