import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/models/product.dart';

class CartNotifier extends Notifier<Set<Product>> {
  // inital value
  @override
  Set<Product> build() {
    return {
      const Product(
        id: '4',
        title: 'Red Backpack',
        price: 14,
        image: 'assets/products/backpack.png',
      ),
    };
  }

  // method update state
  void addProduct(Product product) {
    if (!state.contains(product)) {
      state = {...state, product};
    }
  }

  void removeProduct(Product product) {
    if (state.contains(product)) {
      state = state.where((p) => p.id != product.id).toSet();
    }
  }
}

final cartNotifierProvider = NotifierProvider<CartNotifier, Set<Product>>(() {
  return CartNotifier();
});
