import 'package:flutter/material.dart';

class MyWrap1 extends StatelessWidget {
  const MyWrap1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            "https://images.pexels.com/photos/1212487/pexels-photo-1212487.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
        const Positioned(
          bottom: 20,
          left: 12,
          right: 12,
          child: Card(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Lorem Ipsum",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 12),
                Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
              ],
            ),
          )),
        )
      ],
    );
  }
}
