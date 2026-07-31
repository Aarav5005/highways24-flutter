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

    final availableJobsCount = requests.where((r) => r.status == MechanicRequestStatus.requested).length;
    final activeJob = requests.where((r) => r.status == MechanicRequestStatus.onTheWay || r.status == MechanicRequestStatus.servicing).firstOrNull;
    final totalEarnings = requests.where((r) => r.status == MechanicRequestStatus.completed).fold(0.0, (sum, r) => sum + r.estimatedCost);

    return Scaffold(
      body: RefreshIndicator(
        color: AppTheme.accentGold,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mechanic Shop Banner Header
              Card(
                color: AppTheme.primaryDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppTheme.accentGold,
                        child: Icon(Icons.build, color: AppTheme.primaryDark, size: 28),
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
                              'NH 48 Neemrana Flyover • 24/7 Mobile Breakdown Unit',
                              style: TextStyle(color: AppTheme.accentGold, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Overview Grid: Available Jobs, Service Earnings, Mechanic Rating
              Row(
                children: [
                  Expanded(
                    child: StatBox(
                      label: 'Available Jobs',
                      value: '$availableJobsCount Calls',
                      icon: Icons.engineering,
                      color: AppTheme.accentGold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatBox(
                      label: 'Service Earnings',
                      value: '₹${totalEarnings.round()}',
                      icon: Icons.payments,
                      color: AppTheme.emeraldGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatBox(
                      label: 'Mechanic Rating',
                      value: '4.9 ⭐',
                      icon: Icons.star,
                      color: AppTheme.primaryNavy,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Active Ongoing Job Section (if any)
              if (activeJob != null) ...[
                const Text(
                  'Current Active Repair Job',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  color: AppTheme.surfaceWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
                            Text(
                              activeJob.serviceType.label,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryDark),
                            ),
                            StatusChip(label: activeJob.status.label.toUpperCase(), color: AppTheme.emeraldGreen),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Driver: ${activeJob.driverName} (${activeJob.driverPhone})',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Location: ${activeJob.locationAddress}',
                          style: const TextStyle(color: AppTheme.sosRed, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeJob.status == MechanicRequestStatus.onTheWay ? AppTheme.accentGold : AppTheme.emeraldGreen,
                              foregroundColor: activeJob.status == MechanicRequestStatus.onTheWay ? AppTheme.primaryDark : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              if (activeJob.status == MechanicRequestStatus.onTheWay) {
                                appState.updateMechanicRequestStatus(activeJob.id, MechanicRequestStatus.servicing);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Arrived at location. Repair started.')),
                                );
                              } else {
                                appState.updateMechanicRequestStatus(activeJob.id, MechanicRequestStatus.completed);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Job Completed & Payment collected!')),
                                );
                              }
                            },
                            child: Text(
                              activeJob.status == MechanicRequestStatus.onTheWay ? 'ARRIVED & START REPAIR' : 'MARK JOB COMPLETED',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Incoming Available Breakdown Calls List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Breakdown Calls',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                  ),
                  Text(
                    '${requests.length} Total',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (requests.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No Active Breakdown Calls Right Now',
                        style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              else
                ...requests.map((req) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryDark),
                              ),
                              StatusChip(label: req.status.label.toUpperCase(), color: AppTheme.accentGold),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Driver: ${req.driverName} (${req.driverPhone})',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Vehicle: ${req.vehicleType} [${req.vehicleNumber}]',
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Location: ${req.locationAddress}',
                            style: const TextStyle(color: AppTheme.sosRed, fontWeight: FontWeight.bold, fontSize: 12),
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
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.emeraldGreen,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                    ),
                                    onPressed: () {
                                      appState.updateMechanicRequestStatus(req.id, MechanicRequestStatus.onTheWay);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Request Accepted! On the way to driver.')),
                                      );
                                    },
                                    child: const Text('ACCEPT & GO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
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
      ),
    );
  }
}
