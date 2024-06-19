import 'package:flutter/material.dart';
import 'package:shop_app/global_variables.dart';
import 'package:shop_app/product_card.dart';
import 'package:shop_app/product_detail_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const [
    "All",
    "Adidas",
    "Nike",
    "Puma",
    "Vans",
    "Jordan"
  ];
  int? _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.horizontal(left: Radius.circular(32)),
    );
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
            child: Row(
              children: [
                Text("Shoes\nCollection",
                    style: Theme.of(context).textTheme.titleLarge),
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      print(value);
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.clear),
                      hintText: "Search",
                      border: border,
                      enabledBorder: border,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(filters[index]),
                        labelStyle: const TextStyle(fontSize: 16),
                        selected: _selectedValue == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedValue = selected ? index : 0;
                          });
                        },
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductDetailPage(product: product);
                        },
                      ),
                    );
                  },
                  child: ProductCard(
                    title: product["title"] as String,
                    price: product["price"] as double,
                    image: product["imageUrl"] as String,
                    backgroundColor: index.isEven
                        ? const Color.fromRGBO(216, 240, 253, 1)
                        : const Color.fromRGBO(245, 247, 249, 1),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
