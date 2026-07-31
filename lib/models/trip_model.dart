enum TripStatus {
  planned,
  active,
  paused,
  completed,
  cancelled,
}

extension TripStatusExtension on TripStatus {
  String get label {
    switch (this) {
      case TripStatus.planned:
        return 'Planned';
      case TripStatus.active:
        return 'On the Way';
      case TripStatus.paused:
        return 'On Break';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class TripModel {
  final String id;
  final String driverId;
  final String origin;
  final String destination;
  final double totalKm;
  final double drivenKm;
  final DateTime startTime;
  final DateTime? endTime;
  final TripStatus status;
  final List<String> waypoints;
  final List<String> pitstops;

  TripModel({
    required this.id,
    required this.driverId,
    required this.origin,
    required this.destination,
    required this.totalKm,
    this.drivenKm = 0.0,
    required this.startTime,
    this.endTime,
    required this.status,
    this.waypoints = const [],
    this.pitstops = const [],
  });

  double get progressPercentage {
    if (totalKm <= 0) return 0.0;
    final ratio = drivenKm / totalKm;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  double get remainingKm {
    final rem = totalKm - drivenKm;
    return rem < 0 ? 0.0 : rem;
  }

  TripModel copyWith({
    String? id,
    String? driverId,
    String? origin,
    String? destination,
    double? totalKm,
    double? drivenKm,
    DateTime? startTime,
    DateTime? endTime,
    TripStatus? status,
    List<String>? waypoints,
    List<String>? pitstops,
  }) {
    return TripModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      totalKm: totalKm ?? this.totalKm,
      drivenKm: drivenKm ?? this.drivenKm,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      waypoints: waypoints ?? this.waypoints,
      pitstops: pitstops ?? this.pitstops,
    );
  }
}
