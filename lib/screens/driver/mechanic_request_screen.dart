import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/mechanic_model.dart';
import '../../models/mechanic_request_model.dart';
import '../../core/widgets/status_chip.dart';

class MechanicRequestScreen extends StatefulWidget {
  const MechanicRequestScreen({super.key});

  @override
  State<MechanicRequestScreen> createState() => _MechanicRequestScreenState();
}

class _MechanicRequestScreenState extends State<MechanicRequestScreen> {
  ServiceType _selectedService = ServiceType.puncture;
  final _locationController = TextEditingController(text: 'NH 48, Km 124 (Near Neemrana Toll Plaza)');
  final _issueDescController = TextEditingController(text: 'Front left truck tire punctured. Require mobile vulcanizing.');
  MechanicModel? _selectedMechanic;

  @override
  void dispose() {
    _locationController.dispose();
    _issueDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final mechanics = appState.mechanics;
    final activeRequests = appState.mechanicRequests;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadside Mechanic Assistance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Mechanic Request Card
            if (activeRequests.isNotEmpty) ...[
              const Text(
                'Live Breakdown Request',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 10),
              Card(
                color: AppTheme.primaryNavy,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'REQ #${activeRequests.first.id}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          StatusChip(
                            label: activeRequests.first.status.label.toUpperCase(),
                            color: AppTheme.accentGold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        activeRequests.first.mechanicName,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Service: ${activeRequests.first.serviceType.label}',
                        style: const TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Location: ${activeRequests.first.locationAddress}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Est. Cost: ₹${activeRequests.first.estimatedCost.round()}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.emeraldGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Calling mechanic ${activeRequests.first.mechanicName}...')),
                              );
                            },
                            icon: const Icon(Icons.phone, size: 16),
                            label: const Text('Call Mechanic', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Text(
              'Select Breakdown Issue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ServiceType.values.map((type) {
                final isSel = type == _selectedService;
                return ChoiceChip(
                  label: Text(type.label),
                  selected: isSel,
                  selectedColor: AppTheme.accentGold,
                  backgroundColor: AppTheme.surfaceWhite,
                  labelStyle: TextStyle(
                    color: isSel ? AppTheme.primaryDark : AppTheme.textPrimary,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedService = type);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Highway Location / KM Marker',
                        prefixIcon: Icon(Icons.my_location, color: AppTheme.sosRed),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _issueDescController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Describe Breakdown Details',
                        prefixIcon: Icon(Icons.build_circle, color: AppTheme.primaryNavy),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Select Nearby Mobile Mechanic',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 12),

            ...mechanics.map((m) {
              final isSel = _selectedMechanic?.id == m.id || (_selectedMechanic == null && m.id == mechanics.first.id);

              return Card(
                color: isSel ? AppTheme.accentGoldLight : AppTheme.surfaceWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: isSel ? AppTheme.accentGold : AppTheme.borderGrey, width: isSel ? 2 : 1),
                ),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () => setState(() => _selectedMechanic = m),
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.primaryNavy,
                    child: Icon(Icons.engineering, color: Colors.white),
                  ),
                  title: Text(m.shopName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${m.distanceKm} km away • ${m.location}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('${m.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Est. ₹${_selectedService.defaultEstimatedCost.round()}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: AppTheme.primaryDark,
                ),
                onPressed: () {
                  final targetMechanic = _selectedMechanic ?? mechanics.first;
                  appState.requestMechanicService(
                    mechanic: targetMechanic,
                    serviceType: _selectedService,
                    issueDescription: _issueDescController.text,
                    locationAddress: _locationController.text,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('⚡ Service requested from ${targetMechanic.shopName}! Mechanic notified.'),
                      backgroundColor: AppTheme.emeraldGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.bolt, size: 24),
                label: const Text('DISPATCH MOBILE MECHANIC', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
