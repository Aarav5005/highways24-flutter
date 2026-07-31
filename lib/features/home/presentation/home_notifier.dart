import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../../dhabas/presentation/dhaba_notifier.dart';
import '../../mechanics/data/mechanic_repository_impl.dart';
import '../../orders/presentation/cart_notifier.dart';
import '../../trip/presentation/trip_notifier.dart';
import '../domain/driver_dashboard_model.dart';
import '../domain/home_repository.dart';
import '../data/home_api.dart';
import '../data/home_repository_impl.dart';

final mechanicRepositoryProvider = Provider((ref) => MechanicRepositoryImpl());

final homeApiProvider = Provider((ref) {
  return HomeApi(ref.watch(dioClientProvider));
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    ref.watch(homeApiProvider),
    ref.watch(dhabaRepositoryProvider),
    ref.watch(mechanicRepositoryProvider),
    ref.watch(orderRepositoryProvider),
    ref.watch(tripRepositoryProvider),
  );
});

final driverDashboardProvider = FutureProvider<DriverDashboardModel>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  final result = await repository.getDriverDashboard();

  if (result.isSuccess && result.dataOrNull != null) {
    return result.dataOrNull!;
  } else {
    throw result.exceptionOrNull ?? Exception('Failed to load driver dashboard');
  }
});
