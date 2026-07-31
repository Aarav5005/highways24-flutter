import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/dhaba_model.dart';
import '../../models/mechanic_model.dart';
import 'dhaba_detail_screen.dart';
import 'mechanic_request_screen.dart';

class PitstopItem {
  final String id;
  final String title;
  final String subtitle;
  final String type; // 'dhaba' or 'mechanic'
  final double distanceKm;
  final double rating;
  final String location;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final dynamic rawData;

  PitstopItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.distanceKm,
    required this.rating,
    required this.location,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.rawData,
  });
}

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSub;
  String _filterCategory = 'All';
  bool _isGpsLoading = true;

  // Default initial camera position (Delhi - Jaipur Highway, Neemrana)
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(27.9812, 76.3811),
    zoom: 11.5,
  );

  @override
  void initState() {
    super.initState();
    _initDeviceLocationService();
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // 📡 AUTO-DETECT REAL DEVICE LOCATION & LISTEN TO LIVE GPS STREAM
  Future<void> _initDeviceLocationService() async {
    setState(() => _isGpsLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _useFallbackLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _useFallbackLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _useFallbackLocation();
        return;
      }

      // Fetch current position
      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _currentPosition = pos;
        _isGpsLoading = false;
      });

      _animateCameraToPosition(pos.latitude, pos.longitude);

      // Stream live GPS updates
      _positionStreamSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50, // update every 50 meters
        ),
      ).listen((Position livePos) {
        if (mounted) {
          setState(() {
            _currentPosition = livePos;
          });
          _animateCameraToPosition(livePos.latitude, livePos.longitude);
        }
      });
    } catch (_) {
      _useFallbackLocation();
    }
  }

  void _useFallbackLocation() {
    if (mounted) {
      setState(() {
        // Fallback highway coordinates (Neemrana NH 48)
        _currentPosition = Position(
          longitude: 76.3811,
          latitude: 27.9812,
          timestamp: DateTime.now(),
          accuracy: 10,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        _isGpsLoading = false;
      });
    }
  }

  void _animateCameraToPosition(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 12.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeTrip = appState.activeTrip;

    final driverLat = _currentPosition?.latitude ?? 27.9812;
    final driverLng = _currentPosition?.longitude ?? 76.3811;

    // Build Markers for Google Maps
    final Set<Marker> markers = {
      // Driver Vehicle Marker
      Marker(
        markerId: const MarkerId('driver_vehicle'),
        position: LatLng(driverLat, driverLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: '🚚 Your Driver Location (Live GPS)'),
      ),
    };

    // Build Unified Pitstops List & Auto-Calculate Real GPS Distances
    List<PitstopItem> allPitstops = [];

    for (var d in appState.dhabas) {
      final meters = Geolocator.distanceBetween(driverLat, driverLng, d.latitude, d.longitude);
      final distKm = meters / 1000.0;

      allPitstops.add(
        PitstopItem(
          id: d.id,
          title: d.name,
          subtitle: d.highway,
          type: 'dhaba',
          distanceKm: distKm,
          rating: d.rating,
          location: d.location,
          imageUrl: d.imageUrl,
          latitude: d.latitude,
          longitude: d.longitude,
          rawData: d,
        ),
      );

      markers.add(
        Marker(
          markerId: MarkerId(d.id),
          position: LatLng(d.latitude, d.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: '🍛 ${d.name}', snippet: '${distKm.toStringAsFixed(1)} km away'),
        ),
      );
    }

    for (var m in appState.mechanics) {
      final meters = Geolocator.distanceBetween(driverLat, driverLng, m.latitude, m.longitude);
      final distKm = meters / 1000.0;

      allPitstops.add(
        PitstopItem(
          id: m.id,
          title: m.shopName,
          subtitle: '${m.servicesOffered.map((s) => s.label).join(", ")} • 24/7 Mobile',
          type: 'mechanic',
          distanceKm: distKm,
          rating: m.rating,
          location: m.location,
          imageUrl: '',
          latitude: m.latitude,
          longitude: m.longitude,
          rawData: m,
        ),
      );

      markers.add(
        Marker(
          markerId: MarkerId(m.id),
          position: LatLng(m.latitude, m.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: '🛠️ ${m.shopName}', snippet: '${distKm.toStringAsFixed(1)} km away'),
        ),
      );
    }

    // STRICT DISTANCE SORTING (Closest to Driver First)
    allPitstops.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    // Filter list by category
    if (_filterCategory == 'Dhabas') {
      allPitstops = allPitstops.where((p) => p.type == 'dhaba').toList();
    } else if (_filterCategory == 'Mechanics') {
      allPitstops = allPitstops.where((p) => p.type == 'mechanic').toList();
    }

    final mapHeight = MediaQuery.of(context).size.height * 0.40;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Navigation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Center on My GPS',
            onPressed: () {
              if (_currentPosition != null) {
                _animateCameraToPosition(_currentPosition!.latitude, _currentPosition!.longitude);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🗺️ UPPER HALF: REAL GOOGLE MAPS WIDGET (40% HEIGHT)
          SizedBox(
            height: mapHeight,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialCamera,
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (_currentPosition != null) {
                      _animateCameraToPosition(_currentPosition!.latitude, _currentPosition!.longitude);
                    }
                  },
                ),

                // GPS LOADING INDICATOR OVERLAY
                if (_isGpsLoading)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: AppTheme.accentGold),
                          SizedBox(height: 10),
                          Text('Auto-Detecting GPS Location...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                // TOP FLOATING GPS OVERLAY BADGE
                Positioned(
                  top: 12,
                  left: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.gps_fixed, color: AppTheme.emeraldGreen, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'GPS AUTO-DETECTED',
                                  style: TextStyle(color: AppTheme.accentGold, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${driverLat.toStringAsFixed(4)}, ${driverLng.toStringAsFixed(4)}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.emeraldGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            activeTrip != null ? '${activeTrip.remainingKm.round()} KM Left' : 'LIVE GPS',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🍽️ LOWER HALF: DISTANCE-SORTED DHABAS & MECHANICS FEED (60% HEIGHT)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FILTER & SORT HEADER BAR
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.near_me, color: AppTheme.primaryNavy, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Pitstops (Auto GPS Distance Sorted)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryDark),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.emeraldGreenLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Closest First',
                                style: TextStyle(color: AppTheme.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // FILTER CHIPS
                        Row(
                          children: ['All', 'Dhabas', 'Mechanics'].map((cat) {
                            final isSel = _filterCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: isSel,
                                selectedColor: AppTheme.accentGold,
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  color: isSel ? AppTheme.primaryDark : AppTheme.textPrimary,
                                ),
                                visualDensity: VisualDensity.compact,
                                onSelected: (val) {
                                  if (val) setState(() => _filterCategory = cat);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // DISTANCE-SORTED CARDS LIST
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemCount: allPitstops.length,
                      itemBuilder: (ctx, idx) {
                        final item = allPitstops[idx];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: item.type == 'dhaba'
                                        ? AppTheme.accentGoldLight
                                        : AppTheme.emeraldGreenLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    item.type == 'dhaba' ? Icons.restaurant : Icons.build,
                                    color: item.type == 'dhaba' ? AppTheme.accentGold : AppTheme.emeraldGreen,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.emeraldGreen,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.star, color: Colors.white, size: 10),
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${item.rating}',
                                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, color: AppTheme.sosRed, size: 12),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${item.distanceKm.toStringAsFixed(1)} km from your current GPS',
                                            style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.bold, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: item.type == 'dhaba' ? AppTheme.accentGold : AppTheme.primaryNavy,
                                    foregroundColor: item.type == 'dhaba' ? AppTheme.primaryDark : Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () {
                                    if (item.type == 'dhaba') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (ctx) => DhabaDetailScreen(dhaba: item.rawData as DhabaModel)),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (ctx) => const MechanicRequestScreen()),
                                      );
                                    }
                                  },
                                  child: Text(
                                    item.type == 'dhaba' ? 'Order' : 'Fix',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
