import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerManager {
  static Marker createDriverMarker({
    required double lat,
    required double lng,
    String title = '🚚 Driver Location',
  }) {
    return Marker(
      markerId: const MarkerId('driver_vehicle'),
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title: title),
    );
  }

  static Marker createDhabaMarker({
    required String id,
    required String name,
    required double lat,
    required double lng,
    required double distanceKm,
  }) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(title: '🍛 $name', snippet: '${distanceKm.toStringAsFixed(1)} km away'),
    );
  }

  static Marker createMechanicMarker({
    required String id,
    required String name,
    required double lat,
    required double lng,
    required double distanceKm,
  }) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: '🛠️ $name', snippet: '${distanceKm.toStringAsFixed(1)} km away'),
    );
  }
}
