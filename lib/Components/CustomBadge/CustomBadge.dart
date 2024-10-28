import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String label; // Define a label parameter
  final VoidCallback? onRemove; // Callback for removing the Custombadge

  const CustomBadge({
    super.key,
    required this.label, // Make label required
    this.onRemove, // Optional callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      margin: const EdgeInsets.only(right: 8.0, bottom: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              if (onRemove != null) {
                onRemove!(); // Call the onRemove callback if it's provided
              }
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}