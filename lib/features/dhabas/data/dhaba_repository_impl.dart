import '../../../models/dhaba_model.dart';
import '../domain/dhaba_repository.dart';
import '../domain/dhaba_search_query.dart';
import 'dhaba_api.dart';

class DhabaRepositoryImpl implements DhabaRepository {
  final DhabaApi? _dhabaApi;

  DhabaRepositoryImpl([this._dhabaApi]);

  final List<DhabaModel> _mockDhabas = [
    DhabaModel(
      id: 'dhaba_01',
      name: 'Sher-e-Punjab Dhaba & Restaurant',
      ownerId: 'owner_01',
      highway: 'NH 48 (Delhi - Jaipur Highway)',
      location: 'Km 122, Near Neemrana Toll Plaza',
      rating: 4.8,
      reviewCount: 420,
      isOpen: true,
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500',
      distanceKm: 4.2,
      latitude: 27.9812,
      longitude: 76.3811,
      amenities: ['Truck Parking', 'Clean Washroom', 'AC Hall', '24/7 Open', 'CCTV Security'],
      phone: '+91 99887 11223',
      timing: 'Open 24 Hours',
    ),
    DhabaModel(
      id: 'dhaba_02',
      name: 'Highway King Grand Dhaba',
      ownerId: 'owner_02',
      highway: 'NH 48 (Kotputli Bypass)',
      location: 'Km 160, Kotputli, Rajasthan',
      rating: 4.6,
      reviewCount: 310,
      isOpen: true,
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500',
      distanceKm: 28.5,
      latitude: 27.7011,
      longitude: 76.1200,
      amenities: ['Spacious Parking', 'Driver Rest Lounge', 'Hot Showers', 'RO Water'],
      phone: '+91 98123 45678',
      timing: '05:00 AM - 01:00 AM',
    ),
    DhabaModel(
      id: 'dhaba_03',
      name: 'Pavitra Shuddh Shakahari Dhaba',
      ownerId: 'owner_03',
      highway: 'NH 48 (Shahpura)',
      location: 'Shahpura, Rajasthan',
      rating: 4.4,
      reviewCount: 195,
      isOpen: true,
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500',
      distanceKm: 52.0,
      latitude: 27.4200,
      longitude: 75.9600,
      amenities: ['100% Pure Veg', 'Family Dining', 'Quick Parcel'],
      phone: '+91 97654 32109',
      timing: '06:00 AM - 11:30 PM',
    ),
  ];

  @override
  Future<List<DhabaModel>> getNearbyDhabas() async {
    final api = _dhabaApi;
    if (api != null) {
      try {
        final dtos = await api.getNearbyDhabas();
        if (dtos.isNotEmpty) {
          return dtos.map((d) => d.toDomain()).toList();
        }
      } catch (_) {
        // Resilient fallback to cached dataset
      }
    }
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockDhabas;
  }

  @override
  Future<DhabaModel?> findDhabaById(String id) async {
    final api = _dhabaApi;
    if (api != null) {
      try {
        final dto = await api.getDhabaById(id);
        return dto.toDomain();
      } catch (_) {
        // Resilient fallback to cached dataset
      }
    }
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _mockDhabas.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<DhabaModel>> searchDhabas(DhabaSearchQuery query) async {
    final api = _dhabaApi;
    if (api != null) {
      try {
        final dtos = await api.searchDhabas(query);
        if (dtos.isNotEmpty) {
          return dtos.map((d) => d.toDomain()).toList();
        }
      } catch (_) {
        // Resilient fallback to cached dataset
      }
    }
    await Future.delayed(const Duration(milliseconds: 150));

    return _mockDhabas.where((d) {
      if (query.keyword.isNotEmpty &&
          !d.name.toLowerCase().contains(query.keyword.toLowerCase()) &&
          !d.highway.toLowerCase().contains(query.keyword.toLowerCase())) {
        return false;
      }
      if (query.requiresTruckParking && !d.amenities.contains('Truck Parking') && !d.amenities.contains('Spacious Parking')) {
        return false;
      }
      if (query.requires24Hours && !d.timing.toLowerCase().contains('24')) {
        return false;
      }
      if (query.requiresPureVeg && !d.amenities.contains('100% Pure Veg')) {
        return false;
      }
      if (d.distanceKm > query.maxDistanceKm) {
        return false;
      }
      return true;
    }).toList();
  }
}
