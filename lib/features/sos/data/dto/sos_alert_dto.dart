import '../../../../models/sos_alert_model.dart';

class SOSAlertDto {
  final String id;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final String timestamp;
  final String status;
  final List<String> notifiedContacts;

  const SOSAlertDto({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.status,
    required this.notifiedContacts,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'location_address': locationAddress,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
      'status': status,
      'notified_contacts': notifiedContacts,
    };
  }

  factory SOSAlertDto.fromJson(Map<String, dynamic> json) {
    return SOSAlertDto(
      id: json['id'] as String? ?? '',
      driverId: json['driver_id'] as String? ?? json['driverId'] as String? ?? '',
      driverName: json['driver_name'] as String? ?? json['driverName'] as String? ?? '',
      driverPhone: json['driver_phone'] as String? ?? json['driverPhone'] as String? ?? '',
      locationAddress: json['location_address'] as String? ?? json['locationAddress'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      status: json['status'] as String? ?? 'active',
      notifiedContacts: (json['notified_contacts'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  SOSAlertModel toDomain() {
    return SOSAlertModel(
      id: id,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      locationAddress: locationAddress,
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.tryParse(timestamp) ?? DateTime.now(),
      status: status == 'resolved' ? SOSAlertStatus.resolved : SOSAlertStatus.active,
      notifiedContacts: notifiedContacts,
    );
  }
}
