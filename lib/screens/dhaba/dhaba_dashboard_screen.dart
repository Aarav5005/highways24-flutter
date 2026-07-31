import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/food_order_model.dart';
import '../../core/widgets/status_chip.dart';

class DhabaDashboardScreen extends StatefulWidget {
  const DhabaDashboardScreen({super.key});

  @override
  State<DhabaDashboardScreen> createState() => _DhabaDashboardScreenState();
}

class _DhabaDashboardScreenState extends State<DhabaDashboardScreen> {
  int _parkingSlots = 12;

  final List<Map<String, dynamic>> _todaySpecials = [
    {'name': 'Rajma Rice Thali', 'price': 120, 'isAvailable': true},
    {'name': 'Butter Aloo Paratha (2 Pcs)', 'price': 80, 'isAvailable': true},
    {'name': 'Special Paneer Thali', 'price': 180, 'isAvailable': true},
    {'name': 'Desi Masala Chai & Toast', 'price': 40, 'isAvailable': true},
  ];

  void _showQuickActionSheet(BuildContext context, String actionTitle) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              actionTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 10),
            Text(
              'Quick management control panel for $actionTitle. Changes apply instantly.',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: AppTheme.primaryDark,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('SAVE & CLOSE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final orders = appState.foodOrders;

    final newOrders = orders.where((o) => o.status == OrderStatus.pending).toList();
    final cookingOrders = orders.where((o) => o.status == OrderStatus.preparing).toList();
    final readyOrders = orders.where((o) => o.status == OrderStatus.ready).toList();

    return Scaffold(
      body: RefreshIndicator(
        color: AppTheme.accentGold,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dhaba Banner Header
              Card(
                color: AppTheme.primaryDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppTheme.accentGold,
                        child: Icon(Icons.storefront, color: AppTheme.primaryDark, size: 28),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sher-e-Punjab Dhaba',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'NH 48, Km 122 Neemrana • Live Kitchen Hub',
                              style: TextStyle(color: AppTheme.accentGold, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔴 PRIORITY 1: INCOMING NEW ORDERS (BIGGEST SECTION)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '1. INCOMING NEW ORDERS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: newOrders.isNotEmpty ? Colors.deepOrange : AppTheme.borderGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${newOrders.length} NEW',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (orders.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              else
                ...orders.map((order) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: order.status == OrderStatus.pending ? Colors.deepOrange : AppTheme.accentGold,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ORDER #${order.id}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              StatusChip(label: order.status.label.toUpperCase(), color: AppTheme.accentGold),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: 6),
                              Text('${order.driverName} (${order.driverPhone})', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.directions_car, size: 16, color: AppTheme.emeraldGreen),
                              SizedBox(width: 6),
                              Text(
                                'Driver arriving in 25 mins',
                                style: TextStyle(color: AppTheme.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          ...order.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item.quantity}x ${item.item.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text('₹${item.totalPrice.round()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 20),

                          Row(
                            children: [
                              Text(
                                'Total: ₹${order.totalAmount.round()}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryNavy),
                              ),
                              const Spacer(),

                              if (order.status == OrderStatus.pending)
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.emeraldGreen,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      appState.updateOrderStatus(order.id, OrderStatus.preparing);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Order Accepted! Added to Cooking Status.')),
                                      );
                                    },
                                    child: const Text('ACCEPT ORDER', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              else if (order.status == OrderStatus.preparing)
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentGold,
                                      foregroundColor: AppTheme.primaryDark,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      appState.updateOrderStatus(order.id, OrderStatus.ready);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Order Marked Ready for Pickup!')),
                                      );
                                    },
                                    child: const Text('MARK READY', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              else if (order.status == OrderStatus.ready)
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryNavy,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      appState.updateOrderStatus(order.id, OrderStatus.completed);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Food Collected & Order Completed!')),
                                      );
                                    },
                                    child: const Text('COLLECTED & COMPLETE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 20),

              // 🍳 PRIORITY 2: COOKING STATUS SUMMARY
              const Text(
                '2. COOKING STATUS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 8),

              Card(
                color: AppTheme.surfaceWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('COOKING NOW', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${cookingOrders.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
                        ],
                      ),
                      Container(height: 30, width: 1, color: AppTheme.borderGrey),
                      Column(
                        children: [
                          const Text('READY FOR PICKUP', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${readyOrders.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🚚 PRIORITY 3: PARKING AVAILABILITY (ONE-TAP EDITABLE + / -)
              const Text(
                '3. PARKING AVAILABILITY',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 8),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryNavy.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_parking, color: AppTheme.primaryNavy, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Truck Parking Available', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('$_parkingSlots Slots Open', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),

                      // One-tap + / - counter
                      IconButton.filledTonal(
                        iconSize: 20,
                        onPressed: () {
                          if (_parkingSlots > 0) {
                            setState(() => _parkingSlots--);
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '$_parkingSlots',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                        ),
                      ),
                      IconButton.filledTonal(
                        iconSize: 20,
                        onPressed: () {
                          setState(() => _parkingSlots++);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🍛 PRIORITY 4: TODAY'S SPECIAL (ONE-TAP TOGGLE)
              const Text(
                "4. TODAY'S SPECIAL",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 8),

              ..._todaySpecials.map((special) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: SwitchListTile(
                    dense: true,
                    title: Text(special['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('₹${special['price']}', style: const TextStyle(color: AppTheme.emeraldGreen, fontWeight: FontWeight.bold)),
                    value: special['isAvailable'] as bool,
                    activeThumbColor: AppTheme.emeraldGreen,
                    onChanged: (val) {
                      setState(() {
                        special['isAvailable'] = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${special['name']} availability updated.')),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 20),

              // ⚡ PRIORITY 5: QUICK ACTIONS (EXACTLY 5 BUTTONS)
              const Text(
                '5. QUICK ACTIONS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _QuickActionButton(
                    title: 'Update Parking',
                    icon: Icons.local_parking,
                    onTap: () => _showQuickActionSheet(context, 'Update Parking Capacity'),
                  ),
                  _QuickActionButton(
                    title: "Today's Special",
                    icon: Icons.star,
                    onTap: () => _showQuickActionSheet(context, "Today's Special Dishes"),
                  ),
                  _QuickActionButton(
                    title: 'Menu',
                    icon: Icons.restaurant_menu,
                    onTap: () => _showQuickActionSheet(context, 'Manage Full Menu Inventory'),
                  ),
                  _QuickActionButton(
                    title: 'Order History',
                    icon: Icons.history,
                    onTap: () => _showQuickActionSheet(context, 'Past Order Logs'),
                  ),
                  _QuickActionButton(
                    title: 'Profile',
                    icon: Icons.store,
                    onTap: () => _showQuickActionSheet(context, 'Dhaba Store Profile'),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryDark,
          side: const BorderSide(color: AppTheme.borderGrey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: AppTheme.primaryNavy),
        label: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}
