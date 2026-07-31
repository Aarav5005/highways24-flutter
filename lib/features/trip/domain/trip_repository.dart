import '../../../models/trip_model.dart';

abstract class TripRepository {
  Future<TripModel?> getActiveTrip();
  Future<List<TripModel>> getTripHistory();
  Future<void> startTrip(String origin, String destination, double totalKm);
  Future<void> updateTripProgress(double additionalKm);
  Future<void> completeTrip();
}
