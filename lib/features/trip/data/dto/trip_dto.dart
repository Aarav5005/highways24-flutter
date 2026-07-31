import '../../../../models/trip_model.dart';

class TripDto {
  final String id;
  final String driverId;
  final String origin;
  final String destination;
  final double totalKm;
  final double drivenKm;
  final String startTime;
  final String? endTime;
  final String status;
  final List<String> waypoints;
  final List<String> pitstops;

  const TripDto({
    required this.id,
    required this.driverId,
    required this.origin,
    required this.destination,
    required this.totalKm,
    required this.drivenKm,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.waypoints,
    required this.pitstops,
  });

  factory TripDto.fromJson(Map<String, dynamic> json) {
    return TripDto(
      id: json['id'] as String? ?? '',
      driverId: json['driver_id'] as String? ?? json['driverId'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      totalKm: (json['total_km'] as num?)?.toDouble() ?? (json['totalKm'] as num?)?.toDouble() ?? 0.0,
      drivenKm: (json['driven_km'] as num?)?.toDouble() ?? (json['drivenKm'] as num?)?.toDouble() ?? 0.0,
      startTime: json['start_time'] as String? ?? json['startTime'] as String? ?? DateTime.now().toIso8601String(),
      endTime: json['end_time'] as String? ?? json['endTime'] as String?,
      status: json['status'] as String? ?? 'active',
      waypoints: (json['waypoints'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      pitstops: (json['pitstops'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  TripModel toDomain() {
    TripStatus parsedStatus = TripStatus.active;
    switch (status.toLowerCase()) {
      case 'completed':
        parsedStatus = TripStatus.completed;
        break;
      case 'paused':
        parsedStatus = TripStatus.paused;
        break;
      case 'cancelled':
        parsedStatus = TripStatus.cancelled;
        break;
      default:
        parsedStatus = TripStatus.active;
    }

    return TripModel(
      id: id,
      driverId: driverId,
      origin: origin,
      destination: destination,
      totalKm: totalKm,
      drivenKm: drivenKm,
      startTime: DateTime.tryParse(startTime) ?? DateTime.now(),
      endTime: endTime != null ? DateTime.tryParse(endTime!) : null,
      status: parsedStatus,
      waypoints: waypoints,
      pitstops: pitstops,
    );
  }
}
