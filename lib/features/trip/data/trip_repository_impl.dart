import '../../../../models/trip_model.dart';
import '../domain/trip_repository.dart';
import 'trip_api.dart';
import 'dto/start_trip_request_dto.dart';

class TripRepositoryImpl implements TripRepository {
  final TripApi? _tripApi;

  TripRepositoryImpl([this._tripApi]);

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
    final api = _tripApi;
    if (api != null) {
      try {
        final dto = await api.getActiveTrip();
        if (dto != null) {
          _activeTrip = dto.toDomain();
          return _activeTrip;
        }
      } catch (_) {
        // Resilient offline fallback
      }
    }
    await Future.delayed(const Duration(milliseconds: 150));
    return _activeTrip;
  }

  @override
  Future<List<TripModel>> getTripHistory() async {
    final api = _tripApi;
    if (api != null) {
      try {
        final dtos = await api.getTripHistory();
        if (dtos.isNotEmpty) {
          return dtos.map((d) => d.toDomain()).toList();
        }
      } catch (_) {
        // Resilient offline fallback
      }
    }
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_tripHistory);
  }

  @override
  Future<void> startTrip(String origin, String destination, double totalKm) async {
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

    final api = _tripApi;
    if (api != null) {
      try {
        final dto = await api.startTrip(
          StartTripRequestDto(
            origin: origin,
            destination: destination,
            totalKm: totalKm,
          ),
        );
        _activeTrip = dto.toDomain();
      } catch (_) {
        // Ignored, active locally
      }
    }
  }

  @override
  Future<void> updateTripProgress(double additionalKm) async {
    if (_activeTrip != null) {
      final newDriven = _activeTrip!.drivenKm + additionalKm;
      _activeTrip = _activeTrip!.copyWith(drivenKm: newDriven);
    }

    final api = _tripApi;
    if (api != null) {
      try {
        await api.updateTripProgress(additionalKm);
      } catch (_) {
        // Ignored, updated locally
      }
    }
  }

  @override
  Future<void> completeTrip() async {
    if (_activeTrip != null) {
      final completed = _activeTrip!.copyWith(
        status: TripStatus.completed,
        endTime: DateTime.now(),
      );
      _tripHistory.insert(0, completed);
      _activeTrip = null;
    }

    final api = _tripApi;
    if (api != null) {
      try {
        await api.completeTrip();
      } catch (_) {
        // Ignored, completed locally
      }
    }
  }
}
