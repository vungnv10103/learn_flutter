import 'package:flutter/material.dart';

class ForecastItem extends StatelessWidget {
  final String time;
  final String image;
  final String temperature;

  const ForecastItem(
      {super.key,
      required this.time,
      required this.image,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(
              image,
              height: 56,
              width: 56,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              '$temperature ℃',
              style: const TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
