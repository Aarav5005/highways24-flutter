import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../../../core/storage/offline_sync_queue.dart';
import '../../../models/menu_item_model.dart';
import '../../../models/food_order_model.dart';
import '../domain/cart_service.dart';
import '../domain/order_repository.dart';
import '../data/order_api.dart';
import '../data/order_repository_impl.dart';

final offlineSyncQueueProvider = Provider((ref) => OfflineSyncQueue());

final orderApiProvider = Provider((ref) {
  return OrderApi(ref.watch(dioClientProvider));
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    ref.watch(orderApiProvider),
    ref.watch(offlineSyncQueueProvider),
  );
});

final cartNotifierProvider = StateNotifierProvider<CartNotifier, List<OrderCartItem>>((ref) {
  return CartNotifier(ref.watch(orderRepositoryProvider));
});

class CartNotifier extends StateNotifier<List<OrderCartItem>> {
  final OrderRepository _orderRepository;

  CartNotifier(this._orderRepository) : super([]);

  void addItem(MenuItemModel item) {
    state = CartService.addItem(state, item);
  }

  void removeItem(MenuItemModel item) {
    state = CartService.removeItem(state, item);
  }

  void clearCart() {
    state = [];
  }

  double get subtotal => CartService.calculateSubtotal(state);
  double get taxes => CartService.calculateTaxes(subtotal);
  double get finalAmount => CartService.calculateFinalAmount(subtotal, taxes);

  Future<void> checkout({
    required String driverId,
    required String driverName,
    required String driverPhone,
    required String dhabaId,
    required String dhabaName,
    required String paymentMethod,
  }) async {
    if (state.isEmpty) return;

    final order = FoodOrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      dhabaId: dhabaId,
      dhabaName: dhabaName,
      items: List.from(state),
      totalAmount: finalAmount,
      status: OrderStatus.pending,
      orderTime: DateTime.now(),
      paymentMethod: paymentMethod,
    );

    await _orderRepository.placeOrder(order);
    clearCart();
  }
}
