import '../../../models/mechanic_model.dart';
import '../../../models/mechanic_request_model.dart';
import '../domain/mechanic_repository.dart';

class MechanicRepositoryImpl implements MechanicRepository {
  final List<MechanicModel> _mechanics = [
    MechanicModel(
      id: 'mech_01',
      name: 'Gurmeet Heavy Truck Repair & Vulcanizing',
      shopName: 'Gurmeet Automobile Works',
      phone: '+91 98888 77766',
      location: 'NH 48 Neemrana Flyover',
      rating: 4.9,
      distanceKm: 2.1,
      latitude: 27.9900,
      longitude: 76.3900,
      isAvailable: true,
      servicesOffered: [
        ServiceType.puncture,
        ServiceType.engine,
        ServiceType.towing,
        ServiceType.electrical,
      ],
      basePrice: 300.0,
    ),
    MechanicModel(
      id: 'mech_02',
      name: 'Jai Hanuman Breakdown Services',
      shopName: 'Hanuman Auto Clinic',
      phone: '+91 97777 55443',
      location: 'Shahjahanpur Border, NH 48',
      rating: 4.7,
      distanceKm: 12.0,
      latitude: 28.1100,
      longitude: 76.5000,
      isAvailable: true,
      servicesOffered: [
        ServiceType.puncture,
        ServiceType.fuelDelivery,
        ServiceType.generalCheckup,
      ],
      basePrice: 250.0,
    ),
  ];

  final List<MechanicRequestModel> _requests = [];

  @override
  Future<List<MechanicModel>> getMechanics() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mechanics;
  }

  @override
  Future<MechanicModel?> getMechanicById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _mechanics.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> submitBreakdownRequest(MechanicRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _requests.insert(0, request);
  }
}
