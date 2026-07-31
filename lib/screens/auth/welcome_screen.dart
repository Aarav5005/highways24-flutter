import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import '../../providers/app_state.dart';
import '../../core/localization/app_localizations.dart';
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
    final appState = Provider.of<AppState>(context);
    final loc = AppLocalizations(appState.appLocale);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & App Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.add_road, color: AppTheme.primaryDark, size: 34),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.tr('welcome_title'),
                        style: const TextStyle(
                          color: AppTheme.accentGold,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Text(
                        'India’s Highway Support Network',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🇮🇳 LANGUAGE SELECTION ONBOARDING BAR
              const Text(
                'अपनी भाषा चुनें / Select Language:',
                style: TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _LanguageOptionChip(
                    label: '🇮🇳 हिन्दी',
                    isSelected: appState.appLocale.languageCode == 'hi',
                    onTap: () => appState.setLocale(const Locale('hi')),
                  ),
                  const SizedBox(width: 8),
                  _LanguageOptionChip(
                    label: '🇬🇧 English',
                    isSelected: appState.appLocale.languageCode == 'en',
                    onTap: () => appState.setLocale(const Locale('en')),
                  ),
                  const SizedBox(width: 8),
                  _LanguageOptionChip(
                    label: '🇮🇳 ਪੰਜਾਬੀ',
                    isSelected: appState.appLocale.languageCode == 'pa',
                    onTap: () => appState.setLocale(const Locale('pa')),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Choose Your Role / भूमिका चुनें',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                loc.tr('welcome_subtitle'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 16),

              // Role Onboarding Selection Cards
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _RoleOnboardingCard(
                      title: loc.tr('role_driver'),
                      subtitle: 'Find Verified Dhabas, Order Food & Get 24/7 Breakdown Assistance',
                      icon: Icons.local_shipping,
                      color: AppTheme.accentGold,
                      onTap: () => _selectRoleAndProceed(context, UserRole.driver),
                    ),
                    const SizedBox(height: 14),
                    _RoleOnboardingCard(
                      title: loc.tr('role_dhaba'),
                      subtitle: 'Receive Pre-Orders from Highway Drivers & Manage Parking',
                      icon: Icons.restaurant,
                      color: AppTheme.emeraldGreen,
                      onTap: () => _selectRoleAndProceed(context, UserRole.dhaba),
                    ),
                    const SizedBox(height: 14),
                    _RoleOnboardingCard(
                      title: loc.tr('role_mechanic'),
                      subtitle: 'Receive Highway Breakdown Calls & Mobile Repair Requests',
                      icon: Icons.build,
                      color: Colors.orange.shade700,
                      onTap: () => _selectRoleAndProceed(context, UserRole.mechanic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

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

class _LanguageOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? AppTheme.accentGold : Colors.white10,
            foregroundColor: isSelected ? AppTheme.primaryDark : Colors.white,
            elevation: isSelected ? 2 : 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isSelected ? AppTheme.accentGold : Colors.white24),
            ),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
