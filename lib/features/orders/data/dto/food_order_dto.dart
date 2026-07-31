import '../../../../models/food_order_model.dart';
import '../../../../models/menu_item_model.dart';

class FoodOrderDto {
  final String id;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String dhabaId;
  final String dhabaName;
  final List<dynamic> items;
  final double totalAmount;
  final String status;
  final String orderTime;
  final String paymentMethod;

  const FoodOrderDto({
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
    required this.paymentMethod,
  });

  factory FoodOrderDto.fromJson(Map<String, dynamic> json) {
    return FoodOrderDto(
      id: json['id'] as String? ?? '',
      driverId: json['driver_id'] as String? ?? json['driverId'] as String? ?? '',
      driverName: json['driver_name'] as String? ?? json['driverName'] as String? ?? '',
      driverPhone: json['driver_phone'] as String? ?? json['driverPhone'] as String? ?? '',
      dhabaId: json['dhaba_id'] as String? ?? json['dhabaId'] as String? ?? '',
      dhabaName: json['dhaba_name'] as String? ?? json['dhabaName'] as String? ?? '',
      items: json['items'] as List<dynamic>? ?? [],
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      orderTime: json['order_time'] as String? ?? json['orderTime'] as String? ?? DateTime.now().toIso8601String(),
      paymentMethod: json['payment_method'] as String? ?? json['paymentMethod'] as String? ?? 'Cash on Pickup',
    );
  }

  FoodOrderModel toDomain() {
    final domainItems = items.map((i) {
      final map = i as Map<String, dynamic>;
      final itemObj = MenuItemModel(
        id: map['item_id'] as String? ?? map['id'] as String? ?? '',
        dhabaId: dhabaId,
        name: map['name'] as String? ?? '',
        description: map['description'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        imageUrl: map['image_url'] as String? ?? '',
        category: FoodCategory.mainCourse,
        isVeg: map['is_veg'] as bool? ?? true,
      );
      return OrderCartItem(
        item: itemObj,
        quantity: map['quantity'] as int? ?? 1,
      );
    }).toList();

    OrderStatus parsedStatus = OrderStatus.pending;
    switch (status.toLowerCase()) {
      case 'preparing':
        parsedStatus = OrderStatus.preparing;
        break;
      case 'ready':
        parsedStatus = OrderStatus.ready;
        break;
      case 'completed':
        parsedStatus = OrderStatus.completed;
        break;
      case 'cancelled':
        parsedStatus = OrderStatus.cancelled;
        break;
      default:
        parsedStatus = OrderStatus.pending;
    }

    return FoodOrderModel(
      id: id,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      dhabaId: dhabaId,
      dhabaName: dhabaName,
      items: domainItems,
      totalAmount: totalAmount,
      status: parsedStatus,
      orderTime: DateTime.tryParse(orderTime) ?? DateTime.now(),
      paymentMethod: paymentMethod,
    );
  }
}
