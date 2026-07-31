import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_provider.dart';

class GoogleMapsProvider implements MapProvider {
  const GoogleMapsProvider();

  @override
  Widget buildMapView({
    required LatLng initialPosition,
    required Set<Marker> markers,
    void Function(GoogleMapController controller)? onMapCreated,
  }) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 12.5,
      ),
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: onMapCreated,
    );
  }

  @override
  void animateCamera(GoogleMapController controller, LatLng position, double zoom) {
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(position, zoom),
    );
  }
}
