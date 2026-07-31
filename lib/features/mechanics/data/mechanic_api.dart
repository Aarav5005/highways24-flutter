import '../../../../core/network/dio_client.dart';
import 'dto/mechanic_dto.dart';
import 'dto/mechanic_request_dto.dart';

class MechanicApi {
  final DioClient _dioClient;

  MechanicApi(this._dioClient);

  Future<List<MechanicDto>> getNearbyMechanics() async {
    final response = await _dioClient.get('/mechanics/nearby');
    final list = response.data as List<dynamic>? ?? [];
    return list.map((e) => MechanicDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<MechanicDto> getMechanicById(String id) async {
    final response = await _dioClient.get('/mechanics/$id');
    return MechanicDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> submitBreakdownRequest(MechanicRequestDto request) async {
    await _dioClient.post('/mechanics/request', data: request.toJson());
  }
}
