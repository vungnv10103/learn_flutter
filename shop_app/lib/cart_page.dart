import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    print(Provider.of<CartProvider>(context).cart);
    // final carts = Provider.of<CartProvider>(context).cart;
    final carts = context.watch<CartProvider>().cart;
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: carts.length,
        itemBuilder: (context, index) {
          final cartItem = carts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(cartItem['imageUrl'] as String),
              radius: 30,
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Delete product",
                      ),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                              "Are you sure want to remove the product?",
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            context
                                .read<CartProvider>()
                                .removeProduct(cartItem);
                            // Provider.of<CartProvider>(context, listen: false)
                            //     .removeProduct(cartItem);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Product remove successfully !"),
                            ));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            title: Text(
              cartItem['title'].toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text('Size: ${cartItem["sizes"]}'),
          );
        },
      ),
    );
  }
}
