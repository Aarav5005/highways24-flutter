import '../../../core/errors/result.dart';
import 'driver_dashboard_model.dart';

abstract class HomeRepository {
  Future<Result<DriverDashboardModel>> getDriverDashboard();
}
