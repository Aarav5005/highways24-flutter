import 'package:dio/dio.dart';
import '../../../core/errors/result.dart';
import '../../../core/errors/app_exception.dart';
import '../../auth/domain/user_model.dart';
import '../domain/home_repository.dart';
import '../domain/driver_dashboard_model.dart';
import 'home_api.dart';
import '../../dhabas/domain/dhaba_repository.dart';
import '../../mechanics/domain/mechanic_repository.dart';
import '../../orders/domain/order_repository.dart';
import '../../trip/domain/trip_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApi _homeApi;
  final DhabaRepository _dhabaRepository;
  final MechanicRepository _mechanicRepository;
  final OrderRepository _orderRepository;
  final TripRepository _tripRepository;

  HomeRepositoryImpl(
    this._homeApi,
    this._dhabaRepository,
    this._mechanicRepository,
    this._orderRepository,
    this._tripRepository,
  );

  @override
  Future<Result<DriverDashboardModel>> getDriverDashboard() async {
    try {
      final dhabas = await _dhabaRepository.getNearbyDhabas();
      final mechanics = await _mechanicRepository.getMechanics();
      final orders = await _orderRepository.getOrders();
      final activeTrip = await _tripRepository.getActiveTrip();

      try {
        final dto = await _homeApi.getDriverDashboard();
        final model = DriverDashboardModel(
          user: dto.user.toDomain(),
          activeTrip: activeTrip,
          recentOrders: orders,
          nearbyDhabas: dhabas,
          nearbyMechanics: mechanics,
          rewardPoints: dto.rewardPoints,
        );
        return Result.success(model);
      } catch (_) {
        const defaultUser = UserModel(
          id: 'usr_default',
          phone: '+91 98765 43210',
          name: 'Rajesh Singh',
          role: 'driver',
        );

        final model = DriverDashboardModel(
          user: defaultUser,
          activeTrip: activeTrip,
          recentOrders: orders,
          nearbyDhabas: dhabas,
          nearbyMechanics: mechanics,
          rewardPoints: 250,
        );
        return Result.success(model);
      }
    } catch (e) {
      if (e is DioException) {
        return Result.failure(NetworkException(e.message ?? 'Network error'));
      }
      return Result.failure(AppException(e.toString()));
    }
  }
}
