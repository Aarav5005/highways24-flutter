import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// 1. SINGLE SMART INSIGHT BANNER (For Driver Dashboard)
class SmartInsightBanner extends StatelessWidget {
  final String insightText;
  final IconData icon;

  const SmartInsightBanner({
    super.key,
    required this.insightText,
    this.icon = Icons.auto_awesome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryNavy,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentGold, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.accentGold,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HIGHWAY INTELLIGENCE INSIGHT',
                  style: TextStyle(color: AppTheme.accentGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
                const SizedBox(height: 2),
                Text(
                  insightText,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 2. SMART RECOMMENDATION BADGE CHIP
enum RecommendationType {
  recommendedStop,
  bestParking,
  fastestMechanic,
  cleanWashroom,
  teaBreak,
  fuelNearby,
}

class SmartRecommendationChip extends StatelessWidget {
  final RecommendationType type;

  const SmartRecommendationChip({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    IconData icon;
    Color color;

    switch (type) {
      case RecommendationType.recommendedStop:
        label = 'Recommended Stop';
        icon = Icons.stars;
        color = AppTheme.accentGold;
        break;
      case RecommendationType.bestParking:
        label = 'Best Parking';
        icon = Icons.local_parking;
        color = AppTheme.emeraldGreen;
        break;
      case RecommendationType.fastestMechanic:
        label = 'Fastest Mechanic';
        icon = Icons.flash_on;
        color = Colors.orange.shade800;
        break;
      case RecommendationType.cleanWashroom:
        label = 'Clean Washroom';
        icon = Icons.wc;
        color = AppTheme.primaryNavy;
        break;
      case RecommendationType.teaBreak:
        label = 'Tea Break';
        icon = Icons.local_cafe;
        color = Colors.brown.shade600;
        break;
      case RecommendationType.fuelNearby:
        label = 'Fuel Nearby';
        icon = Icons.local_gas_station;
        color = Colors.blue.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// 3. FATIGUE INTELLIGENCE CARD (Reusable Component)
class FatigueAlertCard extends StatelessWidget {
  final int drivingHours;
  final int nextStopKm;
  final String nextStopName;

  const FatigueAlertCard({
    super.key,
    this.drivingHours = 4,
    this.nextStopKm = 8,
    this.nextStopName = 'Sher-e-Punjab Dhaba',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.shade400, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade800,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_cafe, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DRIVER FATIGUE SAFETY ALERT',
                    style: TextStyle(color: Colors.deepOrange, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'You’ve been driving for $drivingHours hours continuous.',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.primaryDark),
                  ),
                  Text(
                    'Recommended rest stop in $nextStopKm km at $nextStopName.',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
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

// 4. PARKING INTELLIGENCE BADGE
enum ParkingStatus { available, limited, full, unknown }

class ParkingStatusBadge extends StatelessWidget {
  final ParkingStatus status;
  final int slotsCount;

  const ParkingStatusBadge({
    super.key,
    required this.status,
    this.slotsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (status) {
      case ParkingStatus.available:
        label = 'Parking: $slotsCount Slots';
        color = AppTheme.emeraldGreen;
        break;
      case ParkingStatus.limited:
        label = 'Parking: Limited ($slotsCount Slots)';
        color = AppTheme.accentGold;
        break;
      case ParkingStatus.full:
        label = 'Parking: Full (0 Slots)';
        color = AppTheme.sosRed;
        break;
      case ParkingStatus.unknown:
        label = 'Parking: Unknown';
        color = AppTheme.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_parking, color: color, size: 12),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }
}

// 5. MECHANIC INTELLIGENCE BADGE
enum MechanicResponseStatus { available, busy, onAnotherJob, estimatedArrival }

class MechanicStatusBadge extends StatelessWidget {
  final MechanicResponseStatus status;
  final int etaMins;

  const MechanicStatusBadge({
    super.key,
    required this.status,
    this.etaMins = 15,
  });

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (status) {
      case MechanicResponseStatus.available:
        label = 'Available Now';
        color = AppTheme.emeraldGreen;
        break;
      case MechanicResponseStatus.busy:
        label = 'Busy';
        color = AppTheme.accentGold;
        break;
      case MechanicResponseStatus.onAnotherJob:
        label = 'On Another Job';
        color = AppTheme.sosRed;
        break;
      case MechanicResponseStatus.estimatedArrival:
        label = 'Arriving in $etaMins mins';
        color = AppTheme.primaryNavy;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}

// 6. FUEL INTELLIGENCE CARD (Supported: Diesel, Petrol, DEF / AdBlue, Tyre Inflation)
class FuelStationCard extends StatelessWidget {
  final String stationName;
  final String highway;
  final double distanceKm;
  final bool hasDiesel;
  final bool hasDefAdblue;
  final bool hasAirInflation;

  const FuelStationCard({
    super.key,
    required this.stationName,
    required this.highway,
    required this.distanceKm,
    this.hasDiesel = true,
    this.hasDefAdblue = true,
    this.hasAirInflation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.local_gas_station, color: Colors.blue.shade800, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('$highway • $distanceKm km away', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.emeraldGreenLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('OPEN 24/7', style: TextStyle(color: AppTheme.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Fuel Capabilities Chips: Diesel, Petrol, DEF AdBlue, Tyre Air
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (hasDiesel)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(6)),
                    child: const Text('⛽ High-Flow Diesel', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                  ),
                if (hasDefAdblue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.teal.shade100, borderRadius: BorderRadius.circular(6)),
                    child: const Text('💧 DEF / AdBlue Pump', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                  ),
                if (hasAirInflation)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
                    child: const Text('💨 Free Tyre Pressure Air', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
