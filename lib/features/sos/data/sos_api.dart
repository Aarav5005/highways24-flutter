import '../../../../core/network/dio_client.dart';
import 'dto/sos_alert_dto.dart';

class SOSApi {
  final DioClient _dioClient;

  SOSApi(this._dioClient);

  Future<SOSAlertDto> triggerSOS(SOSAlertDto alertDto) async {
    final response = await _dioClient.post('/sos/trigger', data: alertDto.toJson());
    return SOSAlertDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> resolveSOS(String sosId) async {
    await _dioClient.post('/sos/$sosId/resolve');
  }
}
