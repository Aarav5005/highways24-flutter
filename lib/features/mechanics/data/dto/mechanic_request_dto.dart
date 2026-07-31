import '../../../../models/mechanic_request_model.dart';

class MechanicRequestDto {
  final String id;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String mechanicId;
  final String mechanicName;
  final String serviceType;
  final String locationAddress;
  final String issueDescription;

  const MechanicRequestDto({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.mechanicId,
    required this.mechanicName,
    required this.serviceType,
    required this.locationAddress,
    required this.issueDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'mechanic_id': mechanicId,
      'mechanic_name': mechanicName,
      'service_type': serviceType,
      'location_address': locationAddress,
      'issue_description': issueDescription,
    };
  }

  factory MechanicRequestDto.fromDomain(MechanicRequestModel model) {
    return MechanicRequestDto(
      id: model.id,
      driverId: model.driverId,
      driverName: model.driverName,
      driverPhone: model.driverPhone,
      mechanicId: model.mechanicId,
      mechanicName: model.mechanicName,
      serviceType: model.serviceType.name,
      locationAddress: model.locationAddress,
      issueDescription: model.issueDescription,
    );
  }
}
