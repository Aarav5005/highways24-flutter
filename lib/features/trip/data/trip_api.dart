import '../../../../core/network/dio_client.dart';
import 'dto/start_trip_request_dto.dart';
import 'dto/trip_dto.dart';

class TripApi {
  final DioClient _dioClient;

  TripApi(this._dioClient);

  Future<TripDto?> getActiveTrip() async {
    try {
      final response = await _dioClient.get('/trips/active');
      if (response.data == null) return null;
      return TripDto.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<List<TripDto>> getTripHistory() async {
    final response = await _dioClient.get('/trips/history');
    final list = response.data as List<dynamic>? ?? [];
    return list.map((e) => TripDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TripDto> startTrip(StartTripRequestDto request) async {
    final response = await _dioClient.post('/trips/start', data: request.toJson());
    return TripDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateTripProgress(double additionalKm) async {
    await _dioClient.post(
      '/trips/update-progress',
      data: {'additional_km': additionalKm},
    );
  }

  Future<void> completeTrip() async {
    await _dioClient.post('/trips/complete');
  }
}
