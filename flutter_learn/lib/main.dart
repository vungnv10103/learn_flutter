import 'package:flutter/material.dart';

import 'custom_input_field.dart';

void main() {
  // runApp(const ProviderScope(child: MyTask()));
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: "Inter", useMaterial3: true),
    debugShowCheckedModeBanner: false,
    home: SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            elevation: 0,
            title: const Text("Currency Converted"),
            titleTextStyle: const TextStyle(color: Colors.white),
          ),
          body: const CustomInputField()),
    ),
  ));
}
