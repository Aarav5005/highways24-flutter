import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapProvider {
  Widget buildMapView({
    required LatLng initialPosition,
    required Set<Marker> markers,
    void Function(GoogleMapController controller)? onMapCreated,
  });

  void animateCamera(GoogleMapController controller, LatLng position, double zoom);
}
