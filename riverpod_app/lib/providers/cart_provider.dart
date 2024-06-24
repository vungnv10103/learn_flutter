import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_app/models/product.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  // inital value
  @override
  Set<Product> build() {
    return const {};
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
