import '../../../../core/network/dio_client.dart';
import 'dto/create_order_request_dto.dart';
import 'dto/food_order_dto.dart';

class OrderApi {
  final DioClient _dioClient;

  OrderApi(this._dioClient);

  Future<FoodOrderDto> createOrder(CreateOrderRequestDto request) async {
    final response = await _dioClient.post(
      '/orders/create',
      data: request.toJson(),
    );
    return FoodOrderDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<FoodOrderDto>> getMyOrders() async {
    final response = await _dioClient.get('/orders/my-orders');
    final list = response.data as List<dynamic>? ?? [];
    return list.map((e) => FoodOrderDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<FoodOrderDto> getOrderById(String id) async {
    final response = await _dioClient.get('/orders/$id');
    return FoodOrderDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _dioClient.post(
      '/orders/$orderId/status',
      data: {'status': status},
    );
  }
}
