import '../../../../models/food_order_model.dart';
import '../../../../core/storage/offline_sync_queue.dart';
import '../../../../core/events/event_bus.dart';
import '../domain/order_repository.dart';
import 'order_api.dart';
import 'dto/create_order_request_dto.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderApi? _orderApi;
  final OfflineSyncQueue? _syncQueue;
  final List<FoodOrderModel> _localOrders = [];

  OrderRepositoryImpl([this._orderApi, this._syncQueue]);

  @override
  Future<List<FoodOrderModel>> getOrders() async {
    final api = _orderApi;
    if (api != null) {
      try {
        final dtos = await api.getMyOrders();
        if (dtos.isNotEmpty) {
          return dtos.map((d) => d.toDomain()).toList();
        }
      } catch (_) {
        // Resilient fallback to local orders cache
      }
    }
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_localOrders);
  }

  @override
  Future<FoodOrderModel?> getOrderById(String id) async {
    final api = _orderApi;
    if (api != null) {
      try {
        final dto = await api.getOrderById(id);
        return dto.toDomain();
      } catch (_) {
        // Resilient fallback to local cache
      }
    }
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _localOrders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> placeOrder(FoodOrderModel order) async {
    _localOrders.insert(0, order);

    // Publish In-Process Event
    EventBus().publish(
      OrderPlacedEvent(
        orderId: order.id,
        driverId: order.driverId,
        dhabaId: order.dhabaId,
        totalAmount: order.totalAmount,
      ),
    );

    final api = _orderApi;
    if (api != null) {
      try {
        final dto = CreateOrderRequestDto.fromDomain(order, 'idem_${order.id}');
        await api.createOrder(dto);
        return;
      } catch (_) {
        // Enqueue offline pending operation for replay on reconnect
        _syncQueue?.enqueue('PlaceOrder', {
          'order_id': order.id,
          'driver_id': order.driverId,
          'dhaba_id': order.dhabaId,
          'total_amount': order.totalAmount,
        });
      }
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final index = _localOrders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _localOrders[index] = _localOrders[index].copyWith(status: status);
    }

    final api = _orderApi;
    if (api != null) {
      try {
        await api.updateOrderStatus(orderId, status.name);
      } catch (_) {
        // Network error ignored, updated locally
      }
    }
  }
}
