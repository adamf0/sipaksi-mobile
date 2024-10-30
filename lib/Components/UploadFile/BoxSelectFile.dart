import 'package:flutter/material.dart';

class BoxSelectFile extends StatelessWidget {
  final VoidCallback onSelect;

  const BoxSelectFile({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(0),
        child: ElevatedButton(
          onPressed: onSelect,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Center(
            child: Text("Klik disini untuk upload",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          ),
        ),
      ),
    );
  }
}
