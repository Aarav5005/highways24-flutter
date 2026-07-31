import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/food_order_model.dart';
import '../../core/widgets/stat_box.dart';
import '../../core/widgets/status_chip.dart';

class DhabaDashboardScreen extends StatefulWidget {
  const DhabaDashboardScreen({super.key});

  @override
  State<DhabaDashboardScreen> createState() => _DhabaDashboardScreenState();
}

class _DhabaDashboardScreenState extends State<DhabaDashboardScreen> {
  int _parkingSlots = 20;
  int _waitingTimeMins = 15;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final orders = appState.foodOrders;

    final pendingCount = orders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.accepted || o.status == OrderStatus.preparing).length;
    final totalRevenue = orders.fold(0.0, (sum, o) => sum + o.totalAmount);

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
                              'NH 48, Km 122 Neemrana • Verified Partner',
                              style: TextStyle(color: AppTheme.accentGold, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Operational Stats Overview Grid: Revenue, Parking, Waiting Time
              Row(
                children: [
                  Expanded(
                    child: StatBox(
                      label: "Today's Revenue",
                      value: '₹${totalRevenue.round()}',
                      icon: Icons.currency_rupee,
                      color: AppTheme.emeraldGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _parkingSlots = _parkingSlots == 20 ? 15 : 20;
                        });
                      },
                      child: StatBox(
                        label: 'Truck Parking',
                        value: '$_parkingSlots Slots',
                        icon: Icons.local_parking,
                        color: AppTheme.primaryNavy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _waitingTimeMins = _waitingTimeMins == 15 ? 20 : 15;
                        });
                      },
                      child: StatBox(
                        label: 'Waiting Time',
                        value: '$_waitingTimeMins Mins',
                        icon: Icons.timer,
                        color: AppTheme.accentGold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Today's Incoming Orders Feed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Driver Orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGoldLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$pendingCount Active',
                      style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (orders.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No Incoming Orders Today',
                        style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              else
                ...orders.map((order) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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

                          Row(
                            children: [
                              Text(
                                'Total: ₹${order.totalAmount.round()}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryNavy),
                              ),
                              const Spacer(),

                              if (order.status == OrderStatus.pending)
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.emeraldGreen,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                    ),
                                    onPressed: () {
                                      appState.updateOrderStatus(order.id, OrderStatus.preparing);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Order accepted & marked cooking!')),
                                      );
                                    },
                                    child: const Text('ACCEPT & COOK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              else if (order.status == OrderStatus.preparing)
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.accentGold,
                                      foregroundColor: AppTheme.primaryDark,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                    ),
                                    onPressed: () {
                                      appState.updateOrderStatus(order.id, OrderStatus.ready);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Order marked Ready for Pickup!')),
                                      );
                                    },
                                    child: const Text('MARK READY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              else if (order.status == OrderStatus.ready)
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryNavy,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                    ),
                                    onPressed: () {
                                      appState.updateOrderStatus(order.id, OrderStatus.completed);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Order Completed & Paid!')),
                                      );
                                    },
                                    child: const Text('MARK COMPLETED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
