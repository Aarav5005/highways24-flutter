import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/dhaba_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/smart_intelligence_widgets.dart';
import 'trip_planner_screen.dart';
import 'dhaba_detail_screen.dart';
import 'mechanic_request_screen.dart';
import 'driving_mode_screen.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;
    final activeTrip = appState.activeTrip;

    // SINGLE SMART INSIGHT SELECTION LOGIC
    String smartInsightText;
    if (activeTrip != null) {
      smartInsightText = 'Nearest verified dhaba (Sher-e-Punjab) has 20 truck parking slots available on your route.';
    } else if (appState.mechanics.isNotEmpty) {
      smartInsightText = 'Mechanic Gurmeet Automobile Works (2.1 km ahead) is online and available for mobile repair.';
    } else {
      smartInsightText = 'Start a trip now to discover top-rated Dhabas with hot food and clean washrooms.';
    }

    return Scaffold(
      body: RefreshIndicator(
        color: AppTheme.accentGold,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            // 1. Greeting Header
            SliverToBoxAdapter(
              child: Container(
                color: AppTheme.primaryNavy,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Namaste & Safe Drive,',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified, color: AppTheme.primaryDark, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            user.vehicleNumber ?? 'Verified Driver',
                            style: const TextStyle(
                              color: AppTheme.primaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. ⚡ HIGHWAY INTELLIGENCE INSIGHT BANNER (EXACTLY ONE INSIGHT)
                    SmartInsightBanner(insightText: smartInsightText),

                    const SizedBox(height: 16),

                    // 3. Start Trip / Active Trip Banner
                    if (activeTrip != null) ...[
                      Card(
                        elevation: 4,
                        color: AppTheme.surfaceWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppTheme.accentGold, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  StatusChip(label: 'ACTIVE TRIP IN PROGRESS', color: AppTheme.emeraldGreen),
                                  Text(
                                    '${(activeTrip.progressPercentage * 100).round()}% Done',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryNavy),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.trip_origin, color: AppTheme.emeraldGreen, size: 18),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      activeTrip.origin,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: Icon(Icons.arrow_forward, size: 14, color: AppTheme.textSecondary),
                                  ),
                                  const Icon(Icons.location_on, color: AppTheme.sosRed, size: 18),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      activeTrip.destination,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: activeTrip.progressPercentage,
                                  minHeight: 8,
                                  backgroundColor: AppTheme.borderGrey,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.emeraldGreen),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryNavy,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (ctx) => const DrivingModeScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.directions_car, size: 18),
                                  label: const Text('OPEN DRIVING MODE NAVIGATION', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // "No Active Trip" Clean Banner
                      Card(
                        elevation: 3,
                        color: AppTheme.surfaceWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppTheme.borderGrey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.alt_route, color: AppTheme.accentGold, size: 28),
                                  SizedBox(width: 10),
                                  Text(
                                    'No Active Trip',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryDark),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Start a new trip to search verified Dhabas and Mechanics along your highway route.',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.accentGold,
                                    foregroundColor: AppTheme.primaryDark,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (ctx) => const TripPlannerScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('START TRIP NOW', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // 4. ☕ FATIGUE INTELLIGENCE SAFETY ALERT CARD
                    const FatigueAlertCard(
                      drivingHours: 4,
                      nextStopKm: 8,
                      nextStopName: 'Sher-e-Punjab Dhaba Neemrana',
                    ),

                    const SizedBox(height: 24),

                    // 5. Nearby Dhabas Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nearby Verified Dhabas',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                        ),
                        Text(
                          '${appState.dhabas.length} Available',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (appState.dhabas.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'No Dhabas Nearby',
                              style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 215,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: appState.dhabas.length,
                          itemBuilder: (ctx, idx) {
                            final dhaba = appState.dhabas[idx];
                            return Container(
                              width: 250,
                              margin: const EdgeInsets.only(right: 12),
                              child: DhabaCard(
                                dhaba: dhaba,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => DhabaDetailScreen(dhaba: dhaba),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 24),

                    // 6. Nearby Mechanics Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nearby Mechanics',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                        ),
                        Text(
                          '${appState.mechanics.length} Active',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (appState.mechanics.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'No Mechanics Nearby',
                              style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    else
                      ...appState.mechanics.take(2).map((mechanic) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.build, color: Colors.orange.shade800, size: 22),
                            ),
                            title: Text(
                              mechanic.shopName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Text(
                              '${mechanic.distanceKm} km away • ${mechanic.location}',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                            trailing: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentGold,
                                  foregroundColor: AppTheme.primaryDark,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (ctx) => const MechanicRequestScreen()),
                                  );
                                },
                                child: const Text('CALL MECHANIC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        );
                      }),

                    const SizedBox(height: 24),

                    // 7. FUEL STATIONS INTELLIGENCE SECTION
                    const Text(
                      'Highway Fuel Stations & DEF',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                    ),
                    const SizedBox(height: 10),

                    const FuelStationCard(
                      stationName: 'IndianOil Swagat Highway Outlet',
                      highway: 'NH 48 Neemrana Plaza',
                      distanceKm: 3.5,
                      hasDiesel: true,
                      hasDefAdblue: true,
                      hasAirInflation: true,
                    ),

                    const SizedBox(height: 24),

                    // 8. Recent Trip Logs Section
                    const Text(
                      'Recent Trip Logs',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                    ),
                    const SizedBox(height: 10),

                    if (appState.tripHistory.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'No completed trips yet.',
                              style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    else
                      ...appState.tripHistory.map((trip) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            dense: true,
                            leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryNavy.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check_circle, color: AppTheme.emeraldGreen, size: 20),
                            ),
                            title: Text(
                              '${trip.origin} → ${trip.destination}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            subtitle: Text(
                              '${trip.totalKm.round()} km • Completed',
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                            ),
                            trailing: StatusChip(label: 'DONE', color: AppTheme.emeraldGreen),
                          ),
                        );
                      }),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
