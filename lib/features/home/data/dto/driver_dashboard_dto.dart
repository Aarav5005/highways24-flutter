import '../../../auth/data/dto/user_dto.dart';

class DriverDashboardDto {
  final UserDto user;
  final Map<String, dynamic>? activeTrip;
  final List<dynamic> recentOrders;
  final List<dynamic> nearbyDhabas;
  final List<dynamic> nearbyMechanics;
  final int rewardPoints;

  const DriverDashboardDto({
    required this.user,
    this.activeTrip,
    required this.recentOrders,
    required this.nearbyDhabas,
    required this.nearbyMechanics,
    required this.rewardPoints,
  });

  factory DriverDashboardDto.fromJson(Map<String, dynamic> json) {
    return DriverDashboardDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      activeTrip: json['active_trip'] as Map<String, dynamic>?,
      recentOrders: json['recent_orders'] as List<dynamic>? ?? [],
      nearbyDhabas: json['nearby_dhabas'] as List<dynamic>? ?? [],
      nearbyMechanics: json['nearby_mechanics'] as List<dynamic>? ?? [],
      rewardPoints: json['reward_points'] as int? ?? 150,
    );
  }
}
