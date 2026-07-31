import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/mechanic_model.dart';
import '../../models/mechanic_request_model.dart';
import '../../core/widgets/status_chip.dart';

class MechanicDashboardScreen extends StatefulWidget {
  const MechanicDashboardScreen({super.key});

  @override
  State<MechanicDashboardScreen> createState() => _MechanicDashboardScreenState();
}

class _MechanicDashboardScreenState extends State<MechanicDashboardScreen> {
  bool _isOnline = true;
  String _selectedPaymentMethod = 'UPI';

  void _showCollectPaymentModal(BuildContext context, MechanicRequestModel activeJob, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'COLLECT REPAIR PAYMENT',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                    ),
                    Text(
                      '₹${activeJob.estimatedCost.round()}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Driver: ${activeJob.driverName} (${activeJob.vehicleNumber})',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),

                const Text('Choose Payment Method:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),

                Row(
                  children: ['UPI', 'QR Code', 'Cash'].map((method) {
                    final isSel = _selectedPaymentMethod == method;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSel ? AppTheme.accentGold : AppTheme.surfaceWhite,
                              foregroundColor: isSel ? AppTheme.primaryDark : AppTheme.textPrimary,
                              elevation: isSel ? 2 : 0,
                              side: BorderSide(color: isSel ? AppTheme.accentGold : AppTheme.borderGrey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              setModalState(() {
                                _selectedPaymentMethod = method;
                              });
                            },
                            child: Text(method, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.emeraldGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx); // Close payment modal
                      _showRatingDialog(context, activeJob, appState);
                    },
                    icon: const Icon(Icons.check_circle),
                    label: Text('CONFIRM $_selectedPaymentMethod PAYMENT & FINISH', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRatingDialog(BuildContext context, MechanicRequestModel activeJob, AppState appState) {
    int rating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rate Driver & Job Completion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Driver: ${activeJob.driverName}'),
            const SizedBox(height: 12),
            const Text('Driver Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: List.generate(5, (idx) {
                return IconButton(
                  icon: Icon(
                    idx < rating ? Icons.star : Icons.star_border,
                    color: AppTheme.accentGold,
                    size: 28,
                  ),
                  onPressed: () {
                    rating = idx + 1;
                    (ctx as Element).markNeedsBuild();
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'Add job notes / comments (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryNavy, foregroundColor: Colors.white),
              onPressed: () {
                appState.updateMechanicRequestStatus(activeJob.id, MechanicRequestStatus.completed);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎉 Job Finished Successfully! Payment & Rating recorded.')),
                );
              },
              child: const Text('FINISH JOB & SUBMIT RATING', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickActionModal(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
            const SizedBox(height: 8),
            Text('Quick mechanics control panel for $title.', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGold, foregroundColor: AppTheme.primaryDark),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('CLOSE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final requests = appState.mechanicRequests;

    final newRequests = requests.where((r) => r.status == MechanicRequestStatus.requested).toList();
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
              // 1. BIG GO ONLINE / GO OFFLINE SWITCH
              Card(
                color: _isOnline ? AppTheme.emeraldGreen : AppTheme.primaryDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        _isOnline ? Icons.sensors : Icons.sensors_off,
                        color: _isOnline ? Colors.white : Colors.white54,
                        size: 32,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isOnline ? 'MECHANIC IS ONLINE' : 'MECHANIC IS OFFLINE',
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _isOnline ? 'Ready to receive roadside distress calls' : 'Turn on to receive breakdown calls',
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isOnline,
                        activeThumbColor: AppTheme.accentGold,
                        onChanged: (val) {
                          setState(() => _isOnline = val);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_isOnline ? 'You are now ONLINE for breakdown calls.' : 'You are now OFFLINE.')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. ACTIVE JOB SECTION (IF ACCEPTED)
              if (activeJob != null) ...[
                const Text(
                  '2. CURRENT ACTIVE REPAIR JOB',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                ),
                const SizedBox(height: 10),

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
                            Text(
                              activeJob.serviceType.label,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.primaryDark),
                            ),
                            StatusChip(label: activeJob.status.label.toUpperCase(), color: AppTheme.emeraldGreen),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Driver: ${activeJob.driverName} • Vehicle: [${activeJob.vehicleNumber}]',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Location: ${activeJob.locationAddress}',
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
                            'Job Notes: "${activeJob.issueDescription}"',
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Action controls: Call Driver & Navigation
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppTheme.primaryNavy),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Calling Driver ${activeJob.driverPhone}...')),
                                    );
                                  },
                                  icon: const Icon(Icons.phone, size: 18),
                                  label: const Text('CALL DRIVER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryNavy,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Opening Maps Navigation to Driver Location...')),
                                    );
                                  },
                                  icon: const Icon(Icons.navigation, size: 18),
                                  label: const Text('NAVIGATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Status Progression / Payment Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeJob.status == MechanicRequestStatus.onTheWay ? AppTheme.accentGold : AppTheme.emeraldGreen,
                              foregroundColor: activeJob.status == MechanicRequestStatus.onTheWay ? AppTheme.primaryDark : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              if (activeJob.status == MechanicRequestStatus.onTheWay) {
                                appState.updateMechanicRequestStatus(activeJob.id, MechanicRequestStatus.servicing);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Reached Driver! Repair started.')),
                                );
                              } else {
                                _showCollectPaymentModal(context, activeJob, appState);
                              }
                            },
                            child: Text(
                              activeJob.status == MechanicRequestStatus.onTheWay ? 'REACHED DRIVER & START REPAIR' : 'COLLECT PAYMENT & FINISH JOB',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 3. INCOMING JOBS LIST
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '3. INCOMING BREAKDOWN CALLS',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: newRequests.isNotEmpty ? Colors.orange.shade800 : AppTheme.borderGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${newRequests.length} CALLS',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (newRequests.isEmpty && activeJob == null)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No active jobs',
                        style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              else
                ...newRequests.map((req) {
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
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryDark),
                              ),
                              StatusChip(label: 'ETA: 15 MINS', color: AppTheme.accentGold),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Driver Name: ${req.driverName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Truck Number: ${req.vehicleNumber} (${req.vehicleType})', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          Text('Issue: "${req.issueDescription}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                          Text('Distance: 2.1 km away • ${req.locationAddress}', style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 14),

                          // ACCEPT & REJECT BUTTONS (MIN 48DP TOUCH TARGETS)
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.sosRed,
                                      side: const BorderSide(color: AppTheme.sosRed),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Breakdown call rejected.')),
                                      );
                                    },
                                    child: const Text('REJECT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.emeraldGreen,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      appState.updateMechanicRequestStatus(req.id, MechanicRequestStatus.onTheWay);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Job Accepted! Navigate to Driver.')),
                                      );
                                    },
                                    child: const Text('ACCEPT JOB', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 20),

              // 4. TODAY'S EARNINGS
              const Text(
                "4. TODAY'S EARNINGS",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 8),

              Card(
                color: AppTheme.surfaceWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Service Income:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      totalEarnings > 0
                          ? Text('₹${totalEarnings.round()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen))
                          : const Text('No earnings yet', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. QUICK ACTIONS (EXACTLY 4 BUTTONS)
              const Text(
                '5. QUICK ACTIONS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MechanicQuickButton(title: 'History', icon: Icons.history, onTap: () => _showQuickActionModal(context, 'Service Job History')),
                  _MechanicQuickButton(title: 'Profile', icon: Icons.person, onTap: () => _showQuickActionModal(context, 'Mechanic Profile')),
                  _MechanicQuickButton(title: 'Availability', icon: Icons.schedule, onTap: () => _showQuickActionModal(context, 'Operating Hours & Availability')),
                  _MechanicQuickButton(title: 'Support', icon: Icons.help_outline, onTap: () => _showQuickActionModal(context, '24/7 Mechanic Support')),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _MechanicQuickButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MechanicQuickButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryDark,
          side: const BorderSide(color: AppTheme.borderGrey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: AppTheme.primaryNavy),
        label: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}
