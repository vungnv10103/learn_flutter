import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool showCoupon = true;

  @override
  Widget build(BuildContext context) {
    final carts = ref.watch(cartNotifierProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        // actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: carts.length,
                itemBuilder: (context, index) {
                  final cart = carts.elementAt(index);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: [
                        Image.asset(cart.image, width: 60, height: 60),
                        const SizedBox(width: 10),
                        Text(cart.title),
                        const Expanded(child: SizedBox()),
                        Text('\$${cart.price}')
                      ],
                    ),
                  );
                }),
          ),
          Text(
            'Toal price: \$$total',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
