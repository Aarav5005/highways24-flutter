import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/sos_floating_button.dart';

class DrivingModeScreen extends StatefulWidget {
  const DrivingModeScreen({super.key});

  @override
  State<DrivingModeScreen> createState() => _DrivingModeScreenState();
}

class _DrivingModeScreenState extends State<DrivingModeScreen> {
  int _currentStepIndex = 2; // 0: Created, 1: Food Ordered, 2: Navigation Started, 3: Reached Dhaba, 4: Food Collected, 5: Trip Completed

  final List<String> _stages = const [
    'Trip Created',
    'Food Ordered',
    'Navigation Started',
    'Reached Dhaba',
    'Food Collected',
    'Trip Completed',
  ];

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
          'Are you sure you want to complete your current active trip? This will log your trip as completed.',
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
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Return to DriverHomeScreen
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

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.directions_car, color: AppTheme.accentGold),
            SizedBox(width: 10),
            Text('Driving Mode • Real Trip Navigation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. High Visibility Speedometer & Telemetry
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4), width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Column(
                            children: [
                              Text('CURRENT SPEED', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text('65', style: TextStyle(color: AppTheme.accentGold, fontSize: 42, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 4),
                                  Text('KM/H', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          Container(height: 40, width: 1, color: Colors.white24),
                          Column(
                            children: [
                              const Text('ESTIMATED ETA', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              const SizedBox(height: 4),
                              Text(
                                '${(activeTrip.remainingKm / 60 * 60).round()} Mins',
                                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${activeTrip.remainingKm.round()} KM Left',
                                style: const TextStyle(color: AppTheme.emeraldGreen, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 2. Next Stop Indicator
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryNavy,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderGrey.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.restaurant, color: AppTheme.accentGold, size: 28),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NEXT HIGHWAY STOP', style: TextStyle(color: AppTheme.accentGold, fontSize: 10, fontWeight: FontWeight.bold)),
                                SizedBox(height: 2),
                                Text(
                                  'Sher-e-Punjab Dhaba',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '12 KM Ahead • Parking & Hot Food Ready',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 3. Safety & Fatigue Reminder Component
                    Card(
                      color: Colors.orange.shade900.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.orange.shade600, width: 1.5),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.local_cafe, color: Colors.orangeAccent, size: 28),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DRIVER FATIGUE SAFETY ALERT',
                                    style: TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'You’ve been driving for 4 hours continuous.',
                                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Recommended rest stop 12 km ahead at Neemrana.',
                                    style: TextStyle(color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 4. Trip Progress Lifecycle Visualizer
                    const Text(
                      'TRIP LIFECYCLE PROGRESS',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: List.generate(_stages.length, (idx) {
                          final isDone = idx <= _currentStepIndex;
                          final isCurrent = idx == _currentStepIndex;

                          return InkWell(
                            onTap: () {
                              setState(() => _currentStepIndex = idx);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: isCurrent
                                        ? AppTheme.accentGold
                                        : isDone
                                            ? AppTheme.emeraldGreen
                                            : Colors.white30,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _stages[idx],
                                    style: TextStyle(
                                      color: isCurrent
                                          ? AppTheme.accentGold
                                          : isDone
                                              ? Colors.white
                                              : Colors.white38,
                                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isCurrent)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentGold,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text('CURRENT STATE', style: TextStyle(color: AppTheme.primaryDark, fontSize: 9, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. Sticky Bottom Orange "END TRIP" Button (Large CTA 52dp+)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.primaryDark,
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                  ),
                  onPressed: () => _showEndTripConfirmationDialog(context, appState),
                  icon: const Icon(Icons.stop_circle, size: 22),
                  label: const Text(
                    'END TRIP NOW',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const SOSFloatingButton(),
    );
  }
}
