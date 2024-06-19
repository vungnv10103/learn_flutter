import 'package:flutter/material.dart';

class ItemAdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const ItemAdditionalInformation(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        const SizedBox(height: 4),
        Text(label),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
