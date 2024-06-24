import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/providers/cart_provider.dart';
import 'package:riverpod_app/providers/product_provider.dart';
import 'package:riverpod_app/shared/cart_icon.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final carts = ref.watch(cartNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Sale Products'),
        actions: const [CartIcon()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return Container(
              color: Colors.blueGrey.withOpacity(0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(product.image, width: 60, height: 60),
                  Text(product.title),
                  Text('\$${product.price}'),
                  if (carts.contains(product))
                    TextButton(
                      onPressed: () {},
                      child: Text("Remove"),
                    ),
                  if (!carts.contains(product))
                    TextButton(
                      onPressed: () {},
                      child: Text("Add to cart"),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
