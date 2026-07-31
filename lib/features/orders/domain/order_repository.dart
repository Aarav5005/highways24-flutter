import '../../../models/food_order_model.dart';

abstract class OrderRepository {
  Future<List<FoodOrderModel>> getOrders();
  Future<FoodOrderModel?> getOrderById(String id);
  Future<void> placeOrder(FoodOrderModel order);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
}
