import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'phone_login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // Logo & Tagline
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.add_road, color: AppTheme.primaryDark, size: 48),
              ),
              const SizedBox(height: 24),

              const Text(
                'HIGHWAY SETU',
                style: TextStyle(
                  color: AppTheme.accentGold,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'India’s All-in-One Highway Ecosystem & Support Platform',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Trip Navigation • Dhaba Pre-Ordering • Roadside Mobile Mechanics • One-Tap Emergency Panic SOS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Quick Feature Highlights
              const _FeatureTile(
                icon: Icons.local_shipping,
                title: 'Driver Navigation & Trip Logs',
                subtitle: 'Track active trips, toll plazas, and earn loyalty points',
              ),
              const SizedBox(height: 12),
              const _FeatureTile(
                icon: Icons.restaurant,
                title: 'Dhaba Pre-Order Food',
                subtitle: 'Order ahead for hot Desi food at highway arrival time',
              ),
              const SizedBox(height: 12),
              const _FeatureTile(
                icon: Icons.build,
                title: '24/7 Breakdown Assistance',
                subtitle: 'Dispatch nearby mobile mechanics for tires, engine, towing',
              ),

              const SizedBox(height: 32),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGold,
                    foregroundColor: AppTheme.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => const PhoneLoginScreen()),
                    );
                  },
                  child: const Text(
                    'GET STARTED WITH PHONE OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.accentGold, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
