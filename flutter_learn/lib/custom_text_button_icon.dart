import 'package:flutter/material.dart';

class MyTextButtonIcon extends StatelessWidget {
  const MyTextButtonIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: TextButton.icon(
        icon: const Icon(
          Icons.ads_click,
          size: 24,
        ),
        label: const Text("Press me"),
        onPressed: () {
          debugPrint("clicked");
        },
        style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.white,
            // minimumSize: const Size(10, 60),
            padding: const EdgeInsets.all(10.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.5),
            side: const BorderSide(width: 2, color: Colors.grey)),
      ),
    );
  }
}
