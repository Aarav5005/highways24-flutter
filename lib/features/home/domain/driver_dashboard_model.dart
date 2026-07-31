import '../../auth/domain/user_model.dart';
import '../../../models/trip_model.dart';
import '../../../models/dhaba_model.dart';
import '../../../models/mechanic_model.dart';
import '../../../models/food_order_model.dart';

class DriverDashboardModel {
  final UserModel user;
  final TripModel? activeTrip;
  final List<FoodOrderModel> recentOrders;
  final List<DhabaModel> nearbyDhabas;
  final List<MechanicModel> nearbyMechanics;
  final int rewardPoints;

  const DriverDashboardModel({
    required this.user,
    this.activeTrip,
    required this.recentOrders,
    required this.nearbyDhabas,
    required this.nearbyMechanics,
    required this.rewardPoints,
  });
}
