import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Highway Driver Rewards & Loyalty'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Points Balance Card
            Card(
              color: AppTheme.primaryDark,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.stars, color: AppTheme.accentGold, size: 54),
                    const SizedBox(height: 12),
                    Text(
                      '${appState.loyaltyPoints}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Highway Setu Loyalty Points',
                      style: TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Earn 1 Point per 5 KM driven & per ₹10 spent at Dhabas',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Referral Card
            Card(
              color: AppTheme.accentGoldLight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.share, color: AppTheme.primaryDark, size: 32),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invite Fellow Drivers',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'Get +100 bonus points for each driver who joins using your code: HIGHWAY-RAJESH',
                            style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Referral Code copied: HIGHWAY-RAJESH')),
                        );
                      },
                      child: const Text('Share Code'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Redeem Gift Vouchers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 12),

            ...appState.loyaltyRewards.map((reward) {
              final canAfford = appState.loyaltyPoints >= reward.pointsCost;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: reward.isRedeemed
                              ? AppTheme.emeraldGreenLight
                              : AppTheme.accentGoldLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          reward.isRedeemed ? Icons.check_circle : Icons.card_giftcard,
                          color: reward.isRedeemed ? AppTheme.emeraldGreen : AppTheme.accentGold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reward.description,
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            if (reward.isRedeemed)
                              Text(
                                'PROMO: ${reward.promoCode}',
                                style: const TextStyle(color: AppTheme.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 13),
                              )
                            else
                              Text(
                                '${reward.pointsCost} Points',
                                style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      if (reward.isRedeemed)
                        const Chip(
                          label: Text('REDEEMED', style: TextStyle(fontSize: 10, color: Colors.white)),
                          backgroundColor: AppTheme.emeraldGreen,
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canAfford ? AppTheme.accentGold : AppTheme.borderGrey,
                            foregroundColor: canAfford ? AppTheme.primaryDark : AppTheme.textSecondary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          onPressed: canAfford
                              ? () {
                                  appState.redeemLoyaltyReward(reward.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('🎉 Voucher Redeemed! Code: ${reward.promoCode}')),
                                  );
                                }
                              : null,
                          child: const Text('REDEEM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                    ],
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
