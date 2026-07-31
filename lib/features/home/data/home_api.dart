import '../../../core/network/dio_client.dart';
import 'dto/driver_dashboard_dto.dart';

class HomeApi {
  final DioClient _dioClient;

  HomeApi(this._dioClient);

  Future<DriverDashboardDto> getDriverDashboard() async {
    final response = await _dioClient.get('/home/driver-dashboard');
    return DriverDashboardDto.fromJson(response.data as Map<String, dynamic>);
  }
}
