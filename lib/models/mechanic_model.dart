enum ServiceType {
  puncture,
  engine,
  towing,
  electrical,
  fuelDelivery,
  generalCheckup,
}

extension ServiceTypeExtension on ServiceType {
  String get label {
    switch (this) {
      case ServiceType.puncture:
        return 'Tire Puncture / Air';
      case ServiceType.engine:
        return 'Engine & Oil Fault';
      case ServiceType.towing:
        return 'Towing Service';
      case ServiceType.electrical:
        return 'Battery & Electrical';
      case ServiceType.fuelDelivery:
        return 'Emergency Fuel Delivery';
      case ServiceType.generalCheckup:
        return 'General Highway Inspection';
    }
  }

  double get defaultEstimatedCost {
    switch (this) {
      case ServiceType.puncture:
        return 300.0;
      case ServiceType.engine:
        return 1200.0;
      case ServiceType.towing:
        return 2500.0;
      case ServiceType.electrical:
        return 800.0;
      case ServiceType.fuelDelivery:
        return 500.0;
      case ServiceType.generalCheckup:
        return 400.0;
    }
  }
}

class MechanicModel {
  final String id;
  final String name;
  final String shopName;
  final String phone;
  final String location;
  final double rating;
  final double distanceKm;
  final double latitude;
  final double longitude;
  final bool isAvailable;
  final List<ServiceType> servicesOffered;
  final double basePrice;

  MechanicModel({
    required this.id,
    required this.name,
    required this.shopName,
    required this.phone,
    required this.location,
    required this.rating,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    this.isAvailable = true,
    required this.servicesOffered,
    required this.basePrice,
  });

  MechanicModel copyWith({
    String? id,
    String? name,
    String? shopName,
    String? phone,
    String? location,
    double? rating,
    double? distanceKm,
    double? latitude,
    double? longitude,
    bool? isAvailable,
    List<ServiceType>? servicesOffered,
    double? basePrice,
  }) {
    return MechanicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shopName: shopName ?? this.shopName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      distanceKm: distanceKm ?? this.distanceKm,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAvailable: isAvailable ?? this.isAvailable,
      servicesOffered: servicesOffered ?? this.servicesOffered,
      basePrice: basePrice ?? this.basePrice,
    );
  }
}
