import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../models/food_order_model.dart';
import '../../core/widgets/status_chip.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final orderIndex = appState.foodOrders.indexWhere((o) => o.id == orderId);

    if (orderIndex < 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Tracking')),
        body: const Center(child: Text('Order not found.')),
      );
    }

    final order = appState.foodOrders[orderIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Order Status'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: AppTheme.primaryNavy,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ORDER #${order.id}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        StatusChip(label: order.status.label.toUpperCase(), color: AppTheme.accentGold),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      order.dhabaName,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Estimated Prep Time: ~${order.estimatedPrepMins} minutes',
                      style: const TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Live Progress Stepper
            const Text(
              'Preparation Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 16),

            _TimelineTile(
              title: 'Order Placed',
              subtitle: 'Sent to Dhaba kitchen counter',
              isDone: true,
              isCurrent: order.status == OrderStatus.pending,
            ),
            _TimelineTile(
              title: 'Accepted by Dhaba',
              subtitle: 'Chef has received the order',
              isDone: order.status.index >= OrderStatus.accepted.index,
              isCurrent: order.status == OrderStatus.accepted,
            ),
            _TimelineTile(
              title: 'Cooking in Progress',
              subtitle: 'Fresh hot food is being prepared',
              isDone: order.status.index >= OrderStatus.preparing.index,
              isCurrent: order.status == OrderStatus.preparing,
            ),
            _TimelineTile(
              title: 'Ready for Highway Pickup',
              subtitle: 'Parcel ready at counter',
              isDone: order.status.index >= OrderStatus.ready.index,
              isCurrent: order.status == OrderStatus.ready,
            ),

            const SizedBox(height: 24),

            // Items Summary
            const Text(
              'Ordered Food Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.quantity}x  ${item.item.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '₹${item.totalPrice.round()}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDone;
  final bool isCurrent;

  const _TimelineTile({
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDone
        ? AppTheme.emeraldGreen
        : isCurrent
            ? AppTheme.accentGold
            : AppTheme.borderGrey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(
              isDone ? Icons.check : Icons.circle,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDone || isCurrent ? AppTheme.textPrimary : AppTheme.textSecondary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
