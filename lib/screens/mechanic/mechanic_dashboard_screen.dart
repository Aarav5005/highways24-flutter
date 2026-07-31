import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/mechanic_model.dart';
import '../../models/mechanic_request_model.dart';
import '../../core/widgets/stat_box.dart';
import '../../core/widgets/status_chip.dart';

class MechanicDashboardScreen extends StatelessWidget {
  const MechanicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final requests = appState.mechanicRequests;

    final activeJobs = requests.where((r) => r.status != MechanicRequestStatus.completed && r.status != MechanicRequestStatus.cancelled).length;
    final totalEarnings = requests.where((r) => r.status == MechanicRequestStatus.completed).fold(0.0, (sum, r) => sum + r.estimatedCost);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mechanic Shop Banner
            Card(
              color: AppTheme.primaryDark,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.accentGold,
                      child: Icon(Icons.build, color: AppTheme.primaryDark, size: 30),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gurmeet Automobile Works',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'NH 48 Neemrana Flyover • 24/7 Mobile Unit',
                            style: TextStyle(color: AppTheme.accentGold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: StatBox(
                    label: 'Active Jobs',
                    value: '$activeJobs',
                    icon: Icons.engineering,
                    color: AppTheme.accentGold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatBox(
                    label: 'Service Earnings',
                    value: '₹${totalEarnings.round()}',
                    icon: Icons.payments,
                    color: AppTheme.emeraldGreen,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Incoming Driver Breakdown Calls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 12),

            if (requests.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No breakdown distress calls right now.')),
                ),
              )
            else
              ...requests.map((req) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              req.serviceType.label,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryDark),
                            ),
                            StatusChip(label: req.status.label.toUpperCase(), color: AppTheme.accentGold),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Driver: ${req.driverName} (${req.driverPhone})',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vehicle: ${req.vehicleType} [${req.vehicleNumber}]',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Location: ${req.locationAddress}',
                          style: const TextStyle(color: AppTheme.sosRed, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Issue: "${req.issueDescription}"',
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Text(
                              'Fee: ₹${req.estimatedCost.round()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryNavy),
                            ),
                            const Spacer(),

                            if (req.status == MechanicRequestStatus.requested)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emeraldGreen, foregroundColor: Colors.white),
                                onPressed: () {
                                  appState.updateMechanicRequestStatus(req.id, MechanicRequestStatus.onTheWay);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Request Accepted! On the way to driver.')),
                                  );
                                },
                                child: const Text('ACCEPT & GO'),
                              )
                            else if (req.status == MechanicRequestStatus.onTheWay)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGold, foregroundColor: AppTheme.primaryDark),
                                onPressed: () {
                                  appState.updateMechanicRequestStatus(req.id, MechanicRequestStatus.servicing);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Arrived at scene. Repair started.')),
                                  );
                                },
                                child: const Text('START REPAIR'),
                              )
                            else if (req.status == MechanicRequestStatus.servicing)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryNavy, foregroundColor: Colors.white),
                                onPressed: () {
                                  appState.updateMechanicRequestStatus(req.id, MechanicRequestStatus.completed);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Job Completed & Payment collected!')),
                                  );
                                },
                                child: const Text('COMPLETE JOB'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
