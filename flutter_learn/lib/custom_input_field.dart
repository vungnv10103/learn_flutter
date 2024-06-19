import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  const CustomInputField({super.key});

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  double result = 0;
  static const exchangeRate = 25430.00;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.blueGrey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'VND ${result != 0 ? result.toStringAsFixed(2) : result.toStringAsFixed(0)}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: textEditingController,
          onSubmitted: (value) {
            print(value);
          },
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: "Please enter the amount in USD",
            hintStyle: TextStyle(color: Colors.black26),
            prefixIcon: Icon(Icons.monetization_on),
            prefixIconColor: Colors.black,
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  // color: Colors.red,
                  width: 2.0,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  // color: Colors.red,
                  width: 2.0,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 6.0),
        TextButton(
          onPressed: () {
            if (textEditingController.text.isEmpty) return;
            setState(() {
              result = double.parse(textEditingController.text) * exchangeRate;
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text("Convert"),
        )
      ]),
    );
  }
}
