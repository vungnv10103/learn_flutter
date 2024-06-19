import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/cart_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, Object> product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int? _selectedSize = 0;

  void onTap() {
    Provider.of<CartProvider>(context, listen: false).addProduct({
      "id": widget.product['id'],
      "title": widget.product['title'],
      "price": widget.product['price'],
      "imageUrl": widget.product['imageUrl'],
      "company": widget.product['company'],
      "sizes": (widget.product['sizes'] as List<int>)[_selectedSize!],
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Product add successfully !"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            widget.product['title'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Image(image: AssetImage(widget.product["imageUrl"] as String)),
          ),
          const Spacer(
            flex: 2,
          ),
          Container(
            height: 240,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(245, 247, 249, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${widget.product["price"]}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            (widget.product['sizes'] as List<int>).length,
                        itemBuilder: (context, index) {
                          final size =
                              (widget.product['sizes'] as List<int>)[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: ChoiceChip(
                              label: Text(size.toString()),
                              labelStyle: const TextStyle(fontSize: 16),
                              showCheckmark: false,
                              selected: _selectedSize == index,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedSize = selected ? index : 0;
                                });
                              },
                            ),
                          );
                        }),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: const Size(double.infinity, 50)),
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
