import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/user_model.dart';
import '../../core/theme/app_theme.dart';
import '../home_shell.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final UserRole selectedRole;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.selectedRole,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyAndProceed() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.switchUserRole(widget.selectedRole);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const HomeShell()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Verified Successfully! Welcome to Highway Setu (${widget.selectedRole.displayName}).'),
        backgroundColor: AppTheme.emeraldGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter 6-Digit OTP Code',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 6),
            Text(
              'Sent to ${widget.phoneNumber} via SMS',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),

            const SizedBox(height: 32),

            // OTP Input Box
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 14),
                      decoration: const InputDecoration(
                        hintText: '──────',
                        counterText: '',
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Default Test OTP: 123456',
                      style: TextStyle(color: AppTheme.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 12),
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
                onPressed: _verifyAndProceed,
                icon: const Icon(Icons.check_circle),
                label: const Text('VERIFY & LOGIN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resent OTP to your phone number.')),
                  );
                },
                child: const Text('Didn’t receive SMS? Resend OTP Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
