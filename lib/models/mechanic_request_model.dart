import 'mechanic_model.dart';

enum MechanicRequestStatus {
  requested,
  accepted,
  onTheWay,
  servicing,
  completed,
  cancelled,
}

extension MechanicRequestStatusExtension on MechanicRequestStatus {
  String get label {
    switch (this) {
      case MechanicRequestStatus.requested:
        return 'Request Sent';
      case MechanicRequestStatus.accepted:
        return 'Accepted by Mechanic';
      case MechanicRequestStatus.onTheWay:
        return 'Mechanic On The Way';
      case MechanicRequestStatus.servicing:
        return 'Under Repair';
      case MechanicRequestStatus.completed:
        return 'Job Completed';
      case MechanicRequestStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class MechanicRequestModel {
  final String id;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String mechanicId;
  final String mechanicName;
  final String vehicleType;
  final String vehicleNumber;
  final ServiceType serviceType;
  final String issueDescription;
  final String locationAddress;
  final double estimatedCost;
  final MechanicRequestStatus status;
  final DateTime requestTime;

  MechanicRequestModel({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.mechanicId,
    required this.mechanicName,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.serviceType,
    required this.issueDescription,
    required this.locationAddress,
    required this.estimatedCost,
    required this.status,
    required this.requestTime,
  });

  MechanicRequestModel copyWith({
    String? id,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? mechanicId,
    String? mechanicName,
    String? vehicleType,
    String? vehicleNumber,
    ServiceType? serviceType,
    String? issueDescription,
    String? locationAddress,
    double? estimatedCost,
    MechanicRequestStatus? status,
    DateTime? requestTime,
  }) {
    return MechanicRequestModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      mechanicId: mechanicId ?? this.mechanicId,
      mechanicName: mechanicName ?? this.mechanicName,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      serviceType: serviceType ?? this.serviceType,
      issueDescription: issueDescription ?? this.issueDescription,
      locationAddress: locationAddress ?? this.locationAddress,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      status: status ?? this.status,
      requestTime: requestTime ?? this.requestTime,
    );
  }
}
