import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// 🚚 1. DESI INDIAN TRUCK BRAND GRAPHIC
class TruckBrandIllustration extends StatelessWidget {
  final double size;
  const TruckBrandIllustration({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        color: AppTheme.accentGoldLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accentGold, width: 2),
      ),
      child: Icon(
        Icons.local_shipping,
        color: AppTheme.primaryDark,
        size: size * 0.5,
      ),
    );
  }
}

// 🍛 2. DHABA & KULHAD CHAI BRAND GRAPHIC
class DhabaBrandIllustration extends StatelessWidget {
  final double size;
  const DhabaBrandIllustration({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        color: AppTheme.emeraldGreenLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.emeraldGreen, width: 2),
      ),
      child: Icon(
        Icons.restaurant,
        color: AppTheme.emeraldGreen,
        size: size * 0.5,
      ),
    );
  }
}

// 🛠️ 3. MECHANIC ROADSIDE BRAND GRAPHIC
class MechanicBrandIllustration extends StatelessWidget {
  final double size;
  const MechanicBrandIllustration({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange.shade800, width: 2),
      ),
      child: Icon(
        Icons.build,
        color: Colors.orange.shade800,
        size: size * 0.5,
      ),
    );
  }
}

// 📦 4. UNIFIED BRANDED EMPTY STATE WIDGET
class BrandedEmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const BrandedEmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.inbox,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppTheme.surfaceWhite,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.largeRadius,
        side: const BorderSide(color: AppTheme.borderGrey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.textSecondary, size: 36),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔄 5. UNIFIED BRANDED LOADING OVERLAY
class BrandedLoadingWidget extends StatelessWidget {
  final String message;
  const BrandedLoadingWidget({super.key, this.message = 'Loading Highways24...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppTheme.accentGold,
            strokeWidth: 3,
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
