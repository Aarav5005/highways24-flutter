import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import 'otp_verification_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController(text: '9876543210');
  UserRole _selectedRole = UserRole.driver;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highway Setu Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Your Phone Number',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'We will send a 6-digit SMS OTP code for instant verification.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),

            const SizedBox(height: 24),

            // Role Selection Cards
            const Text(
              'Choose Account Persona Role:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _RoleSelectCard(
                    role: UserRole.driver,
                    title: 'Driver',
                    icon: Icons.local_shipping,
                    isSelected: _selectedRole == UserRole.driver,
                    onTap: () => setState(() => _selectedRole = UserRole.driver),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RoleSelectCard(
                    role: UserRole.dhaba,
                    title: 'Dhaba',
                    icon: Icons.restaurant,
                    isSelected: _selectedRole == UserRole.dhaba,
                    onTap: () => setState(() => _selectedRole = UserRole.dhaba),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _RoleSelectCard(
                    role: UserRole.mechanic,
                    title: 'Mechanic',
                    icon: Icons.build,
                    isSelected: _selectedRole == UserRole.mechanic,
                    onTap: () => setState(() => _selectedRole = UserRole.mechanic),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Phone Input Field
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: AppTheme.primaryDark,
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
                label: const Text('SEND VERIFICATION OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleSelectCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleSelectCard({
    required this.role,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentGoldLight : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accentGold : AppTheme.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryDark : AppTheme.textSecondary, size: 24),
            const SizedBox(height: 6),
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
