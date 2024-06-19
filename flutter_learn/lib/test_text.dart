import 'package:flutter/material.dart';

class MyTextDemo extends StatelessWidget {
  const MyTextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.white,
          // minimumSize: const Size(10, 60),
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.5),
          side: const BorderSide(width: 2, color: Colors.grey)),
      child: const Text("Click me"),
    );
  }
}
