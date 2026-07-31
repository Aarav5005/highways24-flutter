enum SOSAlertStatus {
  active,
  resolved,
  cancelled,
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relation;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relation,
  });
}

class SOSAlertModel {
  final String id;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final SOSAlertStatus status;
  final List<String> notifiedContacts;

  SOSAlertModel({
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

  SOSAlertModel copyWith({
    String? id,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? locationAddress,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    SOSAlertStatus? status,
    List<String>? notifiedContacts,
  }) {
    return SOSAlertModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      notifiedContacts: notifiedContacts ?? this.notifiedContacts,
    );
  }
}
