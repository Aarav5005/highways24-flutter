import '../../../models/food_order_model.dart';
import '../domain/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final List<FoodOrderModel> _orders = [];

  @override
  Future<List<FoodOrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_orders);
  }

  @override
  Future<FoodOrderModel?> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> placeOrder(FoodOrderModel order) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _orders.insert(0, order);
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: status);
    }
  }
}
