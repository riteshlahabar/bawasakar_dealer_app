import 'package:get/get.dart';

import '../models/product_model.dart';

class CartItem {
  CartItem({required this.product, required this.quantity});

  final ProductModel product;
  int quantity;

  double get lineTotal => product.price * quantity;
}

class CartService extends GetxService {
  final items = <CartItem>[].obs;

  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold<double>(0, (sum, item) => sum + item.lineTotal);

  void add(ProductModel product) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      items[index].quantity++;
      items.refresh();
    } else {
      items.add(CartItem(product: product, quantity: 1));
    }
  }

  void decrease(ProductModel product) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;
    if (items[index].quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index].quantity--;
      items.refresh();
    }
  }

  void remove(ProductModel product) {
    items.removeWhere((item) => item.product.id == product.id);
  }

  void clear() => items.clear();

  List<Map<String, dynamic>> toOrderItems() {
    return items.map((item) => {'product_id': item.product.id, 'quantity': item.quantity}).toList();
  }
}
