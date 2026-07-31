import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../theme/app_theme.dart';

class SOSFloatingButton extends StatefulWidget {
  const SOSFloatingButton({super.key});

  @override
  State<SOSFloatingButton> createState() => _SOSFloatingButtonState();
}

class _SOSFloatingButtonState extends State<SOSFloatingButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSOSDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _SOSAlertBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FloatingActionButton.extended(
        onPressed: () => _showSOSDialog(context),
        backgroundColor: AppTheme.sosRed,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.warning_amber_rounded, size: 28),
        label: const Text(
          'EMERGENCY SOS',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
      ),
    );
  }
}

class _SOSAlertBottomSheet extends StatelessWidget {
  const _SOSAlertBottomSheet();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.sosRedLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sos, color: AppTheme.sosRed, size: 36),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Highway Panic Alert',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.sosRed),
                    ),
                    Text(
                      'Broadcast live location & auto-dial help',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderGrey),
            ),
            child: Row(
              children: [
                const Icon(Icons.my_location, color: AppTheme.primaryNavy),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Location: NH 48, Km 124 (Near Neemrana Plaza)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Emergency Contacts to Notify:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          ...appState.emergencyContacts.map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.emeraldGreen, size: 18),
                  const SizedBox(width: 8),
                  Text('${c.name} (${c.relation}) - ', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(c.phone, style: const TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sosRed,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                appState.triggerPanicSOS('NH 48, Km 124 Neemrana');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🚨 SOS Alert Triggered! Emergency team & contacts notified.'),
                    backgroundColor: AppTheme.sosRed,
                  ),
                );
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('TRIGGER PANIC SOS NOW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
