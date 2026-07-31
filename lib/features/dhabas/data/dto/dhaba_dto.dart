import '../../../../models/dhaba_model.dart';

class DhabaDto {
  final String id;
  final String name;
  final String ownerId;
  final String highway;
  final String location;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final String imageUrl;
  final double distanceKm;
  final double latitude;
  final double longitude;
  final List<String> amenities;
  final String phone;
  final String timing;

  const DhabaDto({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.highway,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.imageUrl,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.amenities,
    required this.phone,
    required this.timing,
  });

  factory DhabaDto.fromJson(Map<String, dynamic> json) {
    return DhabaDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? json['ownerId'] as String? ?? '',
      highway: json['highway'] as String? ?? '',
      location: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
      reviewCount: json['review_count'] as int? ?? json['reviewCount'] as int? ?? 0,
      isOpen: json['is_open'] as bool? ?? json['isOpen'] as bool? ?? true,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      phone: json['phone'] as String? ?? '',
      timing: json['timing'] as String? ?? 'Open 24 Hours',
    );
  }

  DhabaModel toDomain() {
    return DhabaModel(
      id: id,
      name: name,
      ownerId: ownerId,
      highway: highway,
      location: location,
      rating: rating,
      reviewCount: reviewCount,
      isOpen: isOpen,
      imageUrl: imageUrl,
      distanceKm: distanceKm,
      latitude: latitude,
      longitude: longitude,
      amenities: amenities,
      phone: phone,
      timing: timing,
    );
  }
}
