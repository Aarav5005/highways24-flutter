import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:highways24_flutter/features/dhabas/data/dhaba_repository_impl.dart';
import 'package:highways24_flutter/features/dhabas/domain/dhaba_search_query.dart';
import 'package:highways24_flutter/features/orders/data/order_repository_impl.dart';
import 'package:highways24_flutter/features/orders/domain/cart_service.dart';
import 'package:highways24_flutter/models/food_order_model.dart';
import 'package:highways24_flutter/models/menu_item_model.dart';
import 'package:highways24_flutter/features/trip/data/trip_repository_impl.dart';
import 'package:highways24_flutter/features/sos/domain/sos_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Highways24 Driver User Journey Validation', () {
    test('Complete Driver Workflow: Auth -> Discovery -> Cart Order -> Trip -> SOS', () async {
      // 1. Mock platform channel storage in test environment
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('plugins.it_dev.com/flutter_secure_storage'),
        (methodCall) async {
          return null;
        },
      );

      // 2. Dhaba Discovery & Search
      final dhabaRepo = DhabaRepositoryImpl();
      final nearbyDhabas = await dhabaRepo.getNearbyDhabas();
      expect(nearbyDhabas.isNotEmpty, isTrue);

      final searchResults = await dhabaRepo.searchDhabas(
        const DhabaSearchQuery(keyword: 'Punjab', requiresTruckParking: true),
      );
      expect(searchResults.isNotEmpty, isTrue);
      expect(searchResults.first.name, contains('Sher-e-Punjab'));

      // 3. Menu Item & Cart Calculation Engine
      final testMenuItem = MenuItemModel(
        id: 'item_01',
        dhabaId: searchResults.first.id,
        name: 'Dal Makhani',
        description: 'Authentic Butter Dal',
        price: 180.0,
        category: FoodCategory.mainCourse,
        isVeg: true,
        imageUrl: '',
      );

      final cartItems = CartService.addItem([], testMenuItem);
      final updatedCart = CartService.addItem(cartItems, testMenuItem); // Quantity = 2
      expect(updatedCart.first.quantity, equals(2));

      final subtotal = CartService.calculateSubtotal(updatedCart);
      expect(subtotal, equals(360.0));

      final taxes = CartService.calculateTaxes(subtotal);
      expect(taxes, equals(18.0));

      final grandTotal = CartService.calculateFinalAmount(subtotal, taxes);
      expect(grandTotal, equals(378.0));

      // 4. Order Placement Transaction
      final orderRepo = OrderRepositoryImpl();
      final testOrder = FoodOrderModel(
        id: 'ord_test_101',
        driverId: 'usr_driver',
        driverName: 'Rajesh Singh',
        driverPhone: '+91 98765 43210',
        dhabaId: searchResults.first.id,
        dhabaName: searchResults.first.name,
        items: updatedCart,
        totalAmount: grandTotal,
        status: OrderStatus.pending,
        orderTime: DateTime.now(),
        paymentMethod: 'Cash on Pickup',
      );

      await orderRepo.placeOrder(testOrder);
      final activeOrders = await orderRepo.getOrders();
      expect(activeOrders.length, equals(1));
      expect(activeOrders.first.id, equals('ord_test_101'));

      // 5. Active Trip Navigation Engine
      final tripRepo = TripRepositoryImpl();
      await tripRepo.startTrip('Delhi', 'Jaipur', 280.0);
      final activeTrip = await tripRepo.getActiveTrip();
      expect(activeTrip, isNotNull);
      expect(activeTrip!.origin, equals('Delhi'));
      expect(activeTrip.destination, equals('Jaipur'));

      await tripRepo.updateTripProgress(45.0);
      final updatedTrip = await tripRepo.getActiveTrip();
      expect(updatedTrip!.drivenKm, equals(45.0));

      await tripRepo.completeTrip();
      final finishedTrip = await tripRepo.getActiveTrip();
      expect(finishedTrip, isNull);

      // 6. SOS Emergency Panic Dispatch
      final sosService = SOSService();
      final sosAlert = await sosService.triggerPanicSOS(
        driverId: 'usr_driver',
        driverName: 'Rajesh Singh',
        driverPhone: '+91 98765 43210',
        locationAddress: 'NH 48 Km 122',
        latitude: 27.9812,
        longitude: 76.3811,
        notifiedContacts: ['+91 99999 00000'],
      );

      expect(sosService.activeAlerts.length, equals(1));
      expect(sosAlert.id, contains('sos_'));

      sosService.resolveAlert(sosAlert.id);
      expect(sosService.activeAlerts.first.status.name, equals('resolved'));
    });
  });
}
