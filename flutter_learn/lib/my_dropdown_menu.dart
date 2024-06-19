import 'package:flutter/material.dart';

class MyDropDownMenu extends StatelessWidget {
  const MyDropDownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        label: const Text("Selected Theme Color"),
        helperText: "Change the color of your app",
        onSelected: (value) {
          debugPrint(value?.value.toString());
        },
        enableFilter: true,
        width: 500.0,
        enableSearch: true,
        dropdownMenuEntries: const <DropdownMenuEntry<Color>>[
          DropdownMenuEntry(value: Colors.red, label: "Red"),
          DropdownMenuEntry(value: Colors.blue, label: "Blue"),
          DropdownMenuEntry(value: Colors.green, label: "Green"),
          DropdownMenuEntry(value: Colors.purple, label: "Purple"),
          DropdownMenuEntry(value: Colors.brown, label: "Brown"),
        ]);
  }
}

class MyOverlayPortal extends StatelessWidget {
  const MyOverlayPortal({super.key});

  @override
  Widget build(BuildContext context) {
    var overlayController = OverlayPortalController();
    return ElevatedButton(
        onPressed: overlayController.toggle,
        child: OverlayPortal(
          controller: overlayController,
          overlayChildBuilder: (BuildContext context) {
            return const Positioned(
              top: 150,
              right: 150,
              child: Text("I'm an overlay"),
            );
          },
          child: const Text("Press me"),
        ));
  }
}
