import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import 'phone_login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _selectRoleAndProceed(BuildContext context, UserRole role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PhoneLoginScreen(initialRole: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Logo & App Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.add_road, color: AppTheme.primaryDark, size: 36),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HIGHWAY SETU',
                        style: TextStyle(
                          color: AppTheme.accentGold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'India’s Highway Support Network',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Choose Your Account Role',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select how you use Highway Setu on Indian highways:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              // Role Onboarding Selection Cards
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _RoleOnboardingCard(
                      title: 'Truck Driver / वाहन चालक',
                      subtitle: 'Find Verified Dhabas, Order Food & Get 24/7 Breakdown Assistance',
                      icon: Icons.local_shipping,
                      color: AppTheme.accentGold,
                      onTap: () => _selectRoleAndProceed(context, UserRole.driver),
                    ),
                    const SizedBox(height: 14),
                    _RoleOnboardingCard(
                      title: 'Dhaba Owner / ढाबा मालिक',
                      subtitle: 'Receive Pre-Orders from Highway Drivers & Manage Parking',
                      icon: Icons.restaurant,
                      color: AppTheme.emeraldGreen,
                      onTap: () => _selectRoleAndProceed(context, UserRole.dhaba),
                    ),
                    const SizedBox(height: 14),
                    _RoleOnboardingCard(
                      title: 'Mechanic / मैकेनिक स्पेशलिस्ट',
                      subtitle: 'Receive Highway Breakdown Calls & Mobile Repair Requests',
                      icon: Icons.build,
                      color: Colors.orange.shade700,
                      onTap: () => _selectRoleAndProceed(context, UserRole.mechanic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  '🔒 Secure Mobile OTP Authentication • No Password Needed',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleOnboardingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleOnboardingCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color, width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
