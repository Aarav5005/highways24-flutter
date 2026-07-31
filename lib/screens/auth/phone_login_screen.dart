import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import 'otp_verification_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  final UserRole initialRole;

  const PhoneLoginScreen({
    super.key,
    this.initialRole = UserRole.driver,
  });

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController(text: '9876543210');
  late UserRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_selectedRole.displayName} Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login as ${_selectedRole.displayName}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Enter your 10-digit mobile number to receive a 6-digit SMS OTP code.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),

            const SizedBox(height: 24),

            // Role Switcher Segment
            const Text(
              'Account Role:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _RoleSelectChip(
                    title: 'Driver',
                    icon: Icons.local_shipping,
                    isSelected: _selectedRole == UserRole.driver,
                    onTap: () => setState(() => _selectedRole = UserRole.driver),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RoleSelectChip(
                    title: 'Dhaba',
                    icon: Icons.restaurant,
                    isSelected: _selectedRole == UserRole.dhaba,
                    onTap: () => setState(() => _selectedRole = UserRole.dhaba),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RoleSelectChip(
                    title: 'Mechanic',
                    icon: Icons.build,
                    isSelected: _selectedRole == UserRole.mechanic,
                    onTap: () => setState(() => _selectedRole = UserRole.mechanic),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Phone Input Field
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppTheme.borderGrey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderGrey),
                      ),
                      child: const Row(
                        children: [
                          Text('🇮🇳', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 6),
                          Text('+91', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        decoration: const InputDecoration(
                          hintText: '98765 43210',
                          counterText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Primary 48dp+ CTA Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: AppTheme.primaryDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final phone = _phoneController.text.trim();
                  if (phone.length == 10) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => OtpVerificationScreen(
                          phoneNumber: '+91 $phone',
                          selectedRole: _selectedRole,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
                    );
                  }
                },
                icon: const Icon(Icons.sms),
                label: const Text('SEND VERIFICATION OTP', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleSelectChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleSelectChip({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentGoldLight : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.accentGold : AppTheme.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryDark : AppTheme.textSecondary, size: 22),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
