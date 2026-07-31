import '../../../../core/network/dio_client.dart';
import '../domain/dhaba_search_query.dart';
import 'dto/dhaba_dto.dart';

class DhabaApi {
  final DioClient _dioClient;

  DhabaApi(this._dioClient);

  Future<List<DhabaDto>> getNearbyDhabas() async {
    final response = await _dioClient.get('/dhabas/nearby');
    final list = response.data as List<dynamic>? ?? [];
    return list.map((item) => DhabaDto.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<DhabaDto> getDhabaById(String id) async {
    final response = await _dioClient.get('/dhabas/$id');
    return DhabaDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<DhabaDto>> searchDhabas(DhabaSearchQuery query) async {
    final response = await _dioClient.get(
      '/dhabas/search',
      queryParameters: {
        'keyword': query.keyword,
        'truck_parking': query.requiresTruckParking,
        'twenty_four_hours': query.requires24Hours,
        'pure_veg': query.requiresPureVeg,
        'max_distance_km': query.maxDistanceKm,
      },
    );
    final list = response.data as List<dynamic>? ?? [];
    return list.map((item) => DhabaDto.fromJson(item as Map<String, dynamic>)).toList();
  }
}
