import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import 'dhaba_detail_screen.dart';
import 'driving_mode_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSub;
  bool _isGpsLoading = true;

  final String _origin = 'Delhi (Kashmere Gate)';
  String _selectedDestination = 'Jaipur (Transport Nagar)';
  double _estimatedDistanceKm = 280.0;

  final List<Map<String, dynamic>> _destinationOptions = const [
    {'name': 'Jaipur (Transport Nagar)', 'km': 280.0},
    {'name': 'Ambala (GT Road)', 'km': 210.0},
    {'name': 'Agra (Yamuna Expressway)', 'km': 230.0},
    {'name': 'Ajmer (NH 48 Bypass)', 'km': 390.0},
  ];

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

      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _currentPosition = pos;
        _isGpsLoading = false;
      });

      _animateCameraToPosition(pos.latitude, pos.longitude);

      _positionStreamSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50,
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

  void _startTripAndNavigate(AppState appState) {
    appState.startNewTrip(_origin, _selectedDestination, _estimatedDistanceKm);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const DrivingModeScreen()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🚚 Trip Started: $_origin ➔ $_selectedDestination'),
        backgroundColor: AppTheme.emeraldGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final driverLat = _currentPosition?.latitude ?? 27.9812;
    final driverLng = _currentPosition?.longitude ?? 76.3811;

    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('driver_vehicle'),
        position: LatLng(driverLat, driverLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: '🚚 Current Location (Live GPS)'),
      ),
    };

    for (var d in appState.dhabas) {
      markers.add(
        Marker(
          markerId: MarkerId(d.id),
          position: LatLng(d.latitude, d.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(title: '🍛 ${d.name}'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start New Trip'),
      ),
      body: Column(
        children: [
          // 🗺️ MAP PREVIEW
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
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
                  },
                ),
                if (_isGpsLoading)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppTheme.accentGold),
                    ),
                  ),
              ],
            ),
          ),

          // 📝 TRIP CONFIGURATION FORM
          Expanded(
            child: Container(
              color: AppTheme.backgroundLight,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location & Destination Fields
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.my_location, color: AppTheme.emeraldGreen, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('CURRENT LOCATION', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                                      Text(_origin, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.deepOrange, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('SELECT DESTINATION', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                                      DropdownButton<String>(
                                        value: _selectedDestination,
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryDark),
                                        items: _destinationOptions.map((opt) {
                                          return DropdownMenuItem<String>(
                                            value: opt['name'] as String,
                                            child: Text('${opt['name']} (${(opt['km'] as double).round()} km)'),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            final found = _destinationOptions.firstWhere((o) => o['name'] == val);
                                            setState(() {
                                              _selectedDestination = val;
                                              _estimatedDistanceKm = found['km'] as double;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Distance & Stops Summary
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderGrey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ESTIMATED DISTANCE', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('${_estimatedDistanceKm.round()} KM', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryNavy)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderGrey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ESTIMATED TIME', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('${(_estimatedDistanceKm / 60).toStringAsFixed(1)} Hrs', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.emeraldGreen)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Suggested Dhabas Along Route
                    const Text(
                      'SUGGESTED DHABAS ALONG ROUTE',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                    ),
                    const SizedBox(height: 8),

                    ...appState.dhabas.take(2).map((dhaba) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.restaurant, color: AppTheme.accentGold),
                          title: Text(dhaba.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text('${dhaba.distanceKm} km away • ${dhaba.location}', style: const TextStyle(fontSize: 11)),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentGold,
                              foregroundColor: AppTheme.primaryDark,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (ctx) => DhabaDetailScreen(dhaba: dhaba)),
                              );
                            },
                            child: const Text('Pre-Order', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Large 48dp+ Primary CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGold,
                          foregroundColor: AppTheme.primaryDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 3,
                        ),
                        onPressed: () => _startTripAndNavigate(appState),
                        icon: const Icon(Icons.navigation, size: 20),
                        label: const Text('START TRIP & NAVIGATE NOW', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
