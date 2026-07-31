import '../../../../models/mechanic_model.dart';

class MechanicDto {
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
  final List<String> servicesOffered;
  final double basePrice;

  const MechanicDto({
    required this.id,
    required this.name,
    required this.shopName,
    required this.phone,
    required this.location,
    required this.rating,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
    required this.servicesOffered,
    required this.basePrice,
  });

  factory MechanicDto.fromJson(Map<String, dynamic> json) {
    return MechanicDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shopName: json['shop_name'] as String? ?? json['shopName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      location: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] as bool? ?? json['isAvailable'] as bool? ?? true,
      servicesOffered: (json['services_offered'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      basePrice: (json['base_price'] as num?)?.toDouble() ?? (json['basePrice'] as num?)?.toDouble() ?? 250.0,
    );
  }

  MechanicModel toDomain() {
    final domainServices = servicesOffered.map((s) {
      switch (s.toLowerCase()) {
        case 'puncture':
          return ServiceType.puncture;
        case 'towing':
          return ServiceType.towing;
        case 'fuel':
        case 'fueldelivery':
          return ServiceType.fuelDelivery;
        case 'battery':
        case 'electrical':
          return ServiceType.electrical;
        case 'engine':
          return ServiceType.engine;
        default:
          return ServiceType.generalCheckup;
      }
    }).toList();

    return MechanicModel(
      id: id,
      name: name,
      shopName: shopName,
      phone: phone,
      location: location,
      rating: rating,
      distanceKm: distanceKm,
      latitude: latitude,
      longitude: longitude,
      isAvailable: isAvailable,
      servicesOffered: domainServices.isEmpty ? [ServiceType.generalCheckup] : domainServices,
      basePrice: basePrice,
    );
  }
}
