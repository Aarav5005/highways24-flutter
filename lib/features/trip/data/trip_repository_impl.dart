import '../../../models/trip_model.dart';
import '../domain/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  TripModel? _activeTrip = TripModel(
    id: 'trip_101',
    driverId: 'usr_driver',
    origin: 'Delhi (Kashmere Gate)',
    destination: 'Jaipur (Transport Nagar)',
    totalKm: 280.0,
    drivenKm: 145.0,
    startTime: DateTime.now().subtract(const Duration(hours: 3)),
    status: TripStatus.active,
    waypoints: ['Gurugram', 'Neemrana', 'Kotputli'],
    pitstops: ['Sher-e-Punjab Dhaba', 'Gurmeet Heavy Repair'],
  );

  final List<TripModel> _tripHistory = [
    TripModel(
      id: 'trip_100',
      driverId: 'usr_driver',
      origin: 'Ambala',
      destination: 'Delhi',
      totalKm: 210.0,
      drivenKm: 210.0,
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: -5)),
      status: TripStatus.completed,
    ),
  ];

  @override
  Future<TripModel?> getActiveTrip() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _activeTrip;
  }

  @override
  Future<List<TripModel>> getTripHistory() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_tripHistory);
  }

  @override
  Future<void> startTrip(String origin, String destination, double totalKm) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _activeTrip = TripModel(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      driverId: 'usr_driver',
      origin: origin,
      destination: destination,
      totalKm: totalKm,
      drivenKm: 0.0,
      startTime: DateTime.now(),
      status: TripStatus.active,
    );
  }

  @override
  Future<void> updateTripProgress(double additionalKm) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (_activeTrip != null) {
      final newDriven = _activeTrip!.drivenKm + additionalKm;
      _activeTrip = _activeTrip!.copyWith(drivenKm: newDriven);
    }
  }

  @override
  Future<void> completeTrip() async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (_activeTrip != null) {
      final completed = _activeTrip!.copyWith(
        status: TripStatus.completed,
        endTime: DateTime.now(),
      );
      _tripHistory.insert(0, completed);
      _activeTrip = null;
    }
  }
}
