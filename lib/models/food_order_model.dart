import 'menu_item_model.dart';

enum OrderStatus {
  pending,
  accepted,
  preparing,
  ready,
  completed,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Order Placed';
      case OrderStatus.accepted:
        return 'Accepted by Dhaba';
      case OrderStatus.preparing:
        return 'In Preparation';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class OrderCartItem {
  final MenuItemModel item;
  int quantity;
  String customNotes;

  OrderCartItem({
    required this.item,
    this.quantity = 1,
    this.customNotes = '',
  });

  double get totalPrice => item.price * quantity;
}

class FoodOrderModel {
  final String id;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String dhabaId;
  final String dhabaName;
  final List<OrderCartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderTime;
  final int estimatedPrepMins;
  final String paymentMethod;

  FoodOrderModel({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.dhabaId,
    required this.dhabaName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderTime,
    this.estimatedPrepMins = 20,
    this.paymentMethod = 'Cash / UPI at Dhaba',
  });

  FoodOrderModel copyWith({
    String? id,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? dhabaId,
    String? dhabaName,
    List<OrderCartItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? orderTime,
    int? estimatedPrepMins,
    String? paymentMethod,
  }) {
    return FoodOrderModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      dhabaId: dhabaId ?? this.dhabaId,
      dhabaName: dhabaName ?? this.dhabaName,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderTime: orderTime ?? this.orderTime,
      estimatedPrepMins: estimatedPrepMins ?? this.estimatedPrepMins,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
