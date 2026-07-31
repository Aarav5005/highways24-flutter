import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/dhaba_card.dart';
import '../../core/widgets/stat_box.dart';
import '../../core/widgets/status_chip.dart';
import 'trip_planner_screen.dart';
import 'dhaba_detail_screen.dart';
import 'mechanic_request_screen.dart';
import 'loyalty_screen.dart';
import 'order_tracking_screen.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;
    final activeTrip = appState.activeTrip;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.primaryNavy,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Namaste & Safe Drive,',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: StatBox(
                          label: 'Total Trips',
                          value: '${appState.completedTripsCount}',
                          icon: Icons.local_shipping,
                          color: AppTheme.primaryNavy,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StatBox(
                          label: 'KM Driven',
                          value: '${appState.totalKmDriven.round()} km',
                          icon: Icons.add_road,
                          color: AppTheme.emeraldGreen,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) => const LoyaltyScreen()),
                            );
                          },
                          child: StatBox(
                            label: 'Points',
                            value: '${appState.loyaltyPoints}',
                            icon: Icons.stars,
                            color: AppTheme.accentGold,
                          ),
                        ),
                      ),
                    ],
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
                  // Active Trip Banner
                  if (activeTrip != null) ...[
                    Card(
                      elevation: 4,
                      color: AppTheme.surfaceWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppTheme.accentGold, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StatusChip(label: 'ACTIVE TRIP', color: AppTheme.emeraldGreen),
                                Text(
                                  'Progress: ${(activeTrip.progressPercentage * 100).round()}%',
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
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Covered: ${activeTrip.drivenKm.round()} / ${activeTrip.totalKm.round()} km',
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (ctx) => const TripPlannerScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.navigation, size: 14),
                                  label: const Text('Manage Trip', style: TextStyle(fontSize: 11)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Card(
                      color: AppTheme.surfaceWhite,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppTheme.accentGoldLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.alt_route, color: AppTheme.accentGold, size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No Active Route',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  Text(
                                    'Plan route to find Dhabas & Mechanics',
                                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (ctx) => const TripPlannerScreen()),
                                );
                              },
                              child: const Text('Start Trip', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Quick Action Buttons Grid
                  const Text(
                    'Highway Quick Services',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          title: 'Breakdown Help',
                          subtitle: 'Mobile Mechanic',
                          icon: Icons.build,
                          color: Colors.orange.shade800,
                          bgColor: Colors.orange.shade50,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) => const MechanicRequestScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickActionCard(
                          title: 'Food Orders',
                          subtitle: 'Live Status',
                          icon: Icons.fastfood,
                          color: AppTheme.emeraldGreen,
                          bgColor: AppTheme.emeraldGreenLight,
                          onTap: () {
                            if (appState.foodOrders.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => OrderTrackingScreen(orderId: appState.foodOrders.first.id),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Select a Dhaba below to order food!')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Nearby Dhabas Header & List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nearby Verified Dhabas',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                      ),
                      Text(
                        '${appState.dhabas.length} Available',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 215,
                    child: ListView.builder(
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

                  const SizedBox(height: 20),

                  // Recent Trip History Section
                  const Text(
                    'Recent Trip Logs',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                  ),
                  const SizedBox(height: 10),
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

                  const SizedBox(height: 80), // bottom space for floating SOS button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
