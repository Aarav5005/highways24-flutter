import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Contact Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _relationController,
              decoration: const InputDecoration(labelText: 'Relation (e.g. Owner, Family)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final phone = _phoneController.text.trim();
              final rel = _relationController.text.trim();

              if (name.isNotEmpty && phone.isNotEmpty) {
                Provider.of<AppState>(context, listen: false).addEmergencyContact(
                  name,
                  phone,
                  rel.isEmpty ? 'Contact' : rel,
                );
                _nameController.clear();
                _phoneController.clear();
                _relationController.clear();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Emergency Contact Added!')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Emergency Contacts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppTheme.sosRedLight,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.shield, color: AppTheme.sosRed, size: 36),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Broadcast List',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.sosRed),
                          ),
                          Text(
                            'When you trigger SOS, these contacts will automatically receive SMS alerts with your live GPS location.',
                            style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Contacts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddContactDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Contact'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...appState.emergencyContacts.map((contact) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.primaryNavy,
                    child: Icon(Icons.phone_in_talk, color: Colors.white, size: 20),
                  ),
                  title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${contact.relation} • ${contact.phone}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: AppTheme.emeraldGreen),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${contact.name} (${contact.phone})...')),
                      );
                    },
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
