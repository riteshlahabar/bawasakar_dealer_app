import '../../../app/data/services/api_client.dart';
import '../models/location_option.dart';

/// Public location lists for the registration and edit-profile forms:
/// states, then the districts of a state, then the talukas of a district.
class LocationApiService {
  LocationApiService(this._client);

  final ApiClient _client;

  Future<List<LocationOption>> states() => _list('/locations/states', 'states');

  Future<List<LocationOption>> districts(String stateCode) =>
      _list('/locations/districts', 'districts', {'state': stateCode});

  Future<List<LocationOption>> subdistricts(String districtCode) =>
      _list('/locations/subdistricts', 'subdistricts', {'district': districtCode});

  Future<List<LocationOption>> _list(
    String endpoint,
    String key, [
    Map<String, dynamic>? query,
  ]) async {
    final response = await _client.getJson(endpoint, query: query);
    final raw = response['data']?[key];

    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map((item) => LocationOption.fromJson(Map<String, dynamic>.from(item)))
        .where((option) => option.code.isNotEmpty)
        .toList();
  }
}
