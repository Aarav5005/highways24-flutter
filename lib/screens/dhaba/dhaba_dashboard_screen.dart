import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/food_order_model.dart';
import '../../models/menu_item_model.dart';
import '../../core/widgets/stat_box.dart';
import '../../core/widgets/status_chip.dart';

class DhabaDashboardScreen extends StatelessWidget {
  const DhabaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final orders = appState.foodOrders;
    final menu = appState.allMenuItems;

    final pendingCount = orders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.accepted || o.status == OrderStatus.preparing).length;
    final totalRevenue = orders.fold(0.0, (sum, o) => sum + o.totalAmount);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dhaba Header Banner
            Card(
              color: AppTheme.primaryDark,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.accentGold,
                      child: Icon(Icons.storefront, color: AppTheme.primaryDark, size: 32),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sher-e-Punjab Dhaba',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'NH 48, Km 122 Neemrana • Verified Partner',
                            style: TextStyle(color: AppTheme.accentGold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Counter
            Row(
              children: [
                Expanded(
                  child: StatBox(
                    label: 'Live Orders',
                    value: '$pendingCount',
                    icon: Icons.kitchen,
                    color: AppTheme.accentGold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatBox(
                    label: 'Total Revenue',
                    value: '₹${totalRevenue.round()}',
                    icon: Icons.currency_rupee,
                    color: AppTheme.emeraldGreen,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Live Driver Orders Feed
            const Text(
              'Incoming Driver Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 12),

            if (orders.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No active orders right now.')),
                ),
              )
            else
              ...orders.map((order) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
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
                            StatusChip(label: order.status.label, color: AppTheme.accentGold),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 16, color: AppTheme.textSecondary),
                            const SizedBox(width: 6),
                            Text('${order.driverName} (${order.driverPhone})'),
                          ],
                        ),
                        const Divider(height: 20),
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item.quantity}x ${item.item.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('₹${item.totalPrice.round()}'),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 20),

                        // Action Buttons to Update Order Status
                        Row(
                          children: [
                            Text(
                              'Total: ₹${order.totalAmount.round()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryNavy),
                            ),
                            const Spacer(),

                            if (order.status == OrderStatus.pending)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emeraldGreen, foregroundColor: Colors.white),
                                onPressed: () {
                                  appState.updateOrderStatus(order.id, OrderStatus.preparing);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Order accepted & marked cooking!')),
                                  );
                                },
                                child: const Text('ACCEPT & COOK'),
                              )
                            else if (order.status == OrderStatus.preparing)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGold, foregroundColor: AppTheme.primaryDark),
                                onPressed: () {
                                  appState.updateOrderStatus(order.id, OrderStatus.ready);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Order marked Ready for Pickup!')),
                                  );
                                },
                                child: const Text('MARK READY'),
                              )
                            else if (order.status == OrderStatus.ready)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryNavy, foregroundColor: Colors.white),
                                onPressed: () {
                                  appState.updateOrderStatus(order.id, OrderStatus.completed);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Order Completed & Paid!')),
                                  );
                                },
                                child: const Text('MARK COMPLETED'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

            const SizedBox(height: 24),

            // Menu Inventory Quick Controls
            const Text(
              'Menu Stock & Availability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 12),

            ...menu.take(4).map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: SwitchListTile(
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('₹${item.price.round()} • ${item.category.label}'),
                  value: item.isAvailable,
                  activeThumbColor: AppTheme.emeraldGreen,
                  onChanged: (val) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.name} availability toggled.')),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
