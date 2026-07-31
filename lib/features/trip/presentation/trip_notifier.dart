import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/trip_model.dart';
import '../domain/trip_repository.dart';
import '../data/trip_repository_impl.dart';

final tripRepositoryProvider = Provider<TripRepository>((ref) => TripRepositoryImpl());

final activeTripNotifierProvider = StateNotifierProvider<ActiveTripNotifier, TripModel?>((ref) {
  return ActiveTripNotifier(ref.watch(tripRepositoryProvider));
});

class ActiveTripNotifier extends StateNotifier<TripModel?> {
  final TripRepository _tripRepository;

  ActiveTripNotifier(this._tripRepository) : super(null) {
    loadActiveTrip();
  }

  Future<void> loadActiveTrip() async {
    state = await _tripRepository.getActiveTrip();
  }

  Future<void> startNewTrip(String origin, String destination, double totalKm) async {
    await _tripRepository.startTrip(origin, destination, totalKm);
    state = await _tripRepository.getActiveTrip();
  }

  Future<void> updateProgress(double additionalKm) async {
    await _tripRepository.updateTripProgress(additionalKm);
    state = await _tripRepository.getActiveTrip();
  }

  Future<void> finishTrip() async {
    await _tripRepository.completeTrip();
    state = null;
  }
}
