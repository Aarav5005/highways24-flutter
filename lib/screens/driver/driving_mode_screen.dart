import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/sos_floating_button.dart';

class DrivingModeScreen extends StatefulWidget {
  const DrivingModeScreen({super.key});

  @override
  State<DrivingModeScreen> createState() => _DrivingModeScreenState();
}

class _DrivingModeScreenState extends State<DrivingModeScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSub;

  bool _isGpsLoading = true;
  final bool _isMapError = false;
  String _activeCategoryFilter = '🍛 Dhabas';
  int _currentStepIndex = 2; // 0: Created, 1: Ordered, 2: Driving, 3: Arrived, 4: Collected, 5: Completed

  final List<String> _highwayCategories = const [
    '🍛 Dhabas',
    '🔧 Mechanics',
    '⛽ Fuel Stations',
    '🚻 Washrooms',
    '🛏 Rest Areas',
    '🚚 Truck Parking',
    '☕ Tea Stops',
  ];

  final List<String> _stages = const [
    'Trip Created',
    'Food Ordered',
    'Driving Mode',
    'Arrived at Dhaba',
    'Food Collected',
    'Trip Completed',
  ];

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(27.9812, 76.3811),
    zoom: 13.0,
  );

  @override
  void initState() {
    super.initState();
    _initGpsLocation();
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initGpsLocation() async {
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

      _animateCamera(pos.latitude, pos.longitude);

      _positionStreamSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 30,
        ),
      ).listen((Position livePos) {
        if (mounted) {
          setState(() {
            _currentPosition = livePos;
          });
          _animateCamera(livePos.latitude, livePos.longitude);
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

  void _animateCamera(double lat, double lng) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 13.5),
    );
  }

  void _showEndTripConfirmationDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.deepOrange, size: 28),
            SizedBox(width: 10),
            Text('End Active Trip?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to end your current active trip? This will log your trip journey.',
          style: TextStyle(fontSize: 14, color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
          ),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                appState.completeActiveTrip();
                Navigator.pop(ctx);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Trip Completed Successfully! Safe driving.'),
                    backgroundColor: AppTheme.emeraldGreen,
                  ),
                );
              },
              child: const Text('YES, END TRIP NOW', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final activeTrip = appState.activeTrip;

    if (activeTrip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Driving Mode')),
        body: const Center(
          child: Text('No Active Trip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      );
    }

    final driverLat = _currentPosition?.latitude ?? 27.9812;
    final driverLng = _currentPosition?.longitude ?? 76.3811;

    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('driver_vehicle'),
        position: LatLng(driverLat, driverLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: '🚚 Your Vehicle (Live GPS)'),
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
      backgroundColor: AppTheme.primaryDark,
      body: Stack(
        children: [
          // 🗺️ 1. MAP VIEW LAYER (Mappls Preferred / Google Maps SDK Provider Anchor)
          _isMapError
              ? Container(
                  color: AppTheme.primaryDark,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map, color: Colors.white38, size: 48),
                        SizedBox(height: 10),
                        Text('Map unavailable', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Check network connectivity or GPS signal', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                )
              : GoogleMap(
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

          // 📡 GPS LOADING / FALLBACK OVERLAY BADGE
          if (_isGpsLoading)
            Positioned(
              top: 45,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: AppTheme.accentGold, strokeWidth: 2)),
                    SizedBox(width: 10),
                    Text('Waiting for GPS signal...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            )
          else
            Positioned(
              top: 45,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.gps_fixed, color: AppTheme.emeraldGreen, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Showing live location (${driverLat.toStringAsFixed(3)}, ${driverLng.toStringAsFixed(3)})',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Icon(Icons.navigation, color: AppTheme.accentGold, size: 18),
                  ],
                ),
              ),
            ),

          // 🏷️ 2. HIGHWAY STOPS FILTER CHIPS BAR (TOP OVERLAY)
          Positioned(
            top: 95,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                physics: const BouncingScrollPhysics(),
                itemCount: _highwayCategories.length,
                itemBuilder: (ctx, idx) {
                  final cat = _highwayCategories[idx];
                  final isSel = _activeCategoryFilter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSel,
                      selectedColor: AppTheme.accentGold,
                      backgroundColor: Colors.black.withValues(alpha: 0.8),
                      labelStyle: TextStyle(
                        color: isSel ? AppTheme.primaryDark : Colors.white,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      visualDensity: VisualDensity.compact,
                      onSelected: (val) {
                        if (val) setState(() => _activeCategoryFilter = cat);
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // ⚡ 3. DRIVING TELEMETRY OVERLAY (SPEED & NEXT TURN)
          Positioned(
            top: 150,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentGold, width: 2),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SPEED', style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('65', style: TextStyle(color: AppTheme.accentGold, fontSize: 36, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Text('km/h', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 150,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryNavy.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderGrey.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.turn_right, color: AppTheme.emeraldGreen, size: 28),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NEXT TURN', style: TextStyle(color: AppTheme.accentGold, fontSize: 9, fontWeight: FontWeight.bold)),
                      Text('In 2.4 km', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Turn right to NH 48', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 📲 4. COLLAPSIBLE & EXPANDABLE BOTTOM SHEET (DOMINO'S / UBER STYLE)
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.22,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  children: [
                    // Sheet Handle Drag Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.borderGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // ⬇️ COLLAPSED VIEW: NEXT STOP, ETA, DISTANCE
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGoldLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.restaurant, color: AppTheme.accentGold, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('NEXT HIGHWAY STOP', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                              const Text('Sher-e-Punjab Dhaba', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryDark)),
                              Text(
                                '${activeTrip.destination} • 12 km ahead',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${(activeTrip.remainingKm / 60 * 60).round()} Mins',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.emeraldGreen),
                            ),
                            Text(
                              '${activeTrip.remainingKm.round()} KM Left',
                              style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Divider(height: 24),

                    // ⬆️ EXPANDED VIEW: ROUTE, DRIVER NOTES, FOOD ORDER STATUS, FATIGUE, STAGES
                    const Text('HIGHWAY JOURNEY DETAILS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                    const SizedBox(height: 10),

                    // Route Summary
                    Card(
                      color: AppTheme.backgroundLight,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.alt_route, color: AppTheme.primaryNavy),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Route: ${activeTrip.origin} ➔ ${activeTrip.destination}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Driver Notes & Food Order Status
                    const Card(
                      elevation: 0,
                      color: AppTheme.backgroundLight,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.fastfood, color: AppTheme.accentGold),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('FOOD ORDER STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                                  Text('Cooking in Kitchen • Ready in 15 mins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Text('12 Truck Parking Slots Available', style: TextStyle(color: AppTheme.emeraldGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Driver Fatigue Safety Alert Component
                    Card(
                      color: Colors.orange.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.orange.shade300),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.local_cafe, color: Colors.deepOrange, size: 24),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('FATIGUE REMINDER', style: TextStyle(color: Colors.deepOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                                  Text('4 hours of continuous driving.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  Text('Recommended rest stop 9 km ahead.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Trip Lifecycle Visual Stepper
                    const Text('TRIP LIFECYCLE PROGRESS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                    const SizedBox(height: 8),

                    Column(
                      children: List.generate(_stages.length, (idx) {
                        final isDone = idx <= _currentStepIndex;
                        final isCurrent = idx == _currentStepIndex;
                        return InkWell(
                          onTap: () => setState(() => _currentStepIndex = idx),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isCurrent
                                      ? AppTheme.accentGold
                                      : isDone
                                          ? AppTheme.emeraldGreen
                                          : AppTheme.borderGrey,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _stages[idx],
                                  style: TextStyle(
                                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                    color: isCurrent ? AppTheme.primaryDark : AppTheme.textPrimary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // STICKY ORANGE END TRIP BUTTON (52DP+)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 3,
                        ),
                        onPressed: () => _showEndTripConfirmationDialog(context, appState),
                        icon: const Icon(Icons.stop_circle, size: 22),
                        label: const Text('END TRIP NOW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: const SOSFloatingButton(),
    );
  }
}
