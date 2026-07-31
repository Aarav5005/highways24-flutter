class DhabaModel {
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

  DhabaModel({
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

  DhabaModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? highway,
    String? location,
    double? rating,
    int? reviewCount,
    bool? isOpen,
    String? imageUrl,
    double? distanceKm,
    double? latitude,
    double? longitude,
    List<String>? amenities,
    String? phone,
    String? timing,
  }) {
    return DhabaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      highway: highway ?? this.highway,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOpen: isOpen ?? this.isOpen,
      imageUrl: imageUrl ?? this.imageUrl,
      distanceKm: distanceKm ?? this.distanceKm,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      amenities: amenities ?? this.amenities,
      phone: phone ?? this.phone,
      timing: timing ?? this.timing,
    );
  }
}
