import '../../../../models/food_order_model.dart';

class CreateOrderRequestDto {
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String dhabaId;
  final String dhabaName;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String paymentMethod;
  final String idempotencyKey;

  const CreateOrderRequestDto({
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.dhabaId,
    required this.dhabaName,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.idempotencyKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'dhaba_id': dhabaId,
      'dhaba_name': dhabaName,
      'items': items,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'idempotency_key': idempotencyKey,
    };
  }

  factory CreateOrderRequestDto.fromDomain(FoodOrderModel order, String idempotencyKey) {
    return CreateOrderRequestDto(
      driverId: order.driverId,
      driverName: order.driverName,
      driverPhone: order.driverPhone,
      dhabaId: order.dhabaId,
      dhabaName: order.dhabaName,
      items: order.items
          .map((i) => {
                'item_id': i.item.id,
                'name': i.item.name,
                'price': i.item.price,
                'quantity': i.quantity,
                'total_price': i.totalPrice,
              })
          .toList(),
      totalAmount: order.totalAmount,
      paymentMethod: order.paymentMethod,
      idempotencyKey: idempotencyKey,
    );
  }
}
