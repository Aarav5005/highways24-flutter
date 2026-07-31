import '../../../models/menu_item_model.dart';
import '../../../models/food_order_model.dart';

class CartService {
  static double calculateSubtotal(List<OrderCartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  static double calculateTaxes(double subtotal) {
    // 5% GST for Dhaba food orders
    return subtotal * 0.05;
  }

  static double calculateFinalAmount(double subtotal, double taxes, [double discount = 0.0]) {
    final total = subtotal + taxes - discount;
    return total < 0 ? 0.0 : total;
  }

  static List<OrderCartItem> addItem(List<OrderCartItem> currentCart, MenuItemModel item) {
    final list = List<OrderCartItem>.from(currentCart);
    final index = list.indexWhere((c) => c.item.id == item.id);
    if (index >= 0) {
      list[index].quantity++;
    } else {
      list.add(OrderCartItem(item: item, quantity: 1));
    }
    return list;
  }

  static List<OrderCartItem> removeItem(List<OrderCartItem> currentCart, MenuItemModel item) {
    final list = List<OrderCartItem>.from(currentCart);
    final index = list.indexWhere((c) => c.item.id == item.id);
    if (index >= 0) {
      if (list[index].quantity > 1) {
        list[index].quantity--;
      } else {
        list.removeAt(index);
      }
    }
    return list;
  }
}
