import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/dhaba_model.dart';
import 'order_tracking_screen.dart';

class FoodCartScreen extends StatefulWidget {
  final DhabaModel dhaba;

  const FoodCartScreen({super.key, required this.dhaba});

  @override
  State<FoodCartScreen> createState() => _FoodCartScreenState();
}

class _FoodCartScreenState extends State<FoodCartScreen> {
  String _selectedPaymentMethod = 'Cash / UPI at Dhaba';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final cart = appState.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart & Pre-Order Checkout'),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text('Your cart is empty.'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dhaba Banner
                  Card(
                    color: AppTheme.primaryNavy,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.storefront, color: AppTheme.accentGold, size: 32),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dhaba.name,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  'Pre-Ordering for Highway Pick-Up',
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                  ),
                  const SizedBox(height: 12),

                  ...cart.map((cartItem) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.item.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${cartItem.item.price.round()} x ${cartItem.quantity}',
                                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₹${cartItem.totalPrice.round()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryNavy),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Bill Details Card
                  Card(
                    color: AppTheme.backgroundLight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Item Total', style: TextStyle(color: AppTheme.textSecondary)),
                              Text('₹${appState.cartTotalAmount.round()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Highway Booking Fee', style: TextStyle(color: AppTheme.textSecondary)),
                              Text('FREE', style: TextStyle(color: AppTheme.emeraldGreen, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Loyalty Bonus Points', style: TextStyle(color: AppTheme.textSecondary)),
                              Text('+${(appState.cartTotalAmount / 10).round()} Points', style: const TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('To Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text(
                                '₹${appState.cartTotalAmount.round()}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryNavy),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Method Selection
                  const Text(
                    'Select Payment Mode',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                  ),
                  const SizedBox(height: 12),

                  _PaymentOptionTile(
                    title: 'Pay Cash / UPI at Dhaba Counter',
                    subtitle: 'Pay directly when you arrive at the Dhaba',
                    icon: Icons.payments,
                    isSelected: _selectedPaymentMethod == 'Cash / UPI at Dhaba',
                    onTap: () => setState(() => _selectedPaymentMethod = 'Cash / UPI at Dhaba'),
                  ),
                  const SizedBox(height: 10),
                  _PaymentOptionTile(
                    title: 'Instant Online UPI Pay',
                    subtitle: 'Pre-pay to skip line',
                    icon: Icons.qr_code,
                    isSelected: _selectedPaymentMethod == 'Online UPI',
                    onTap: () => setState(() => _selectedPaymentMethod = 'Online UPI'),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: AppTheme.primaryDark,
                      ),
                      onPressed: () {
                        appState.placeFoodOrder(
                          widget.dhaba.id,
                          widget.dhaba.name,
                          _selectedPaymentMethod,
                        );
                        final newOrderId = appState.foodOrders.first.id;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => OrderTrackingScreen(orderId: newOrderId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_circle, size: 24),
                      label: const Text('CONFIRM FOOD PRE-ORDER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.title,
    required this.subtitle,
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentGoldLight : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accentGold : AppTheme.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppTheme.primaryDark : AppTheme.textSecondary,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: AppTheme.primaryNavy),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
