import 'package:flutter/material.dart';

class CloseBottomSheet extends StatelessWidget {
  const CloseBottomSheet({Key? key, required this.ctx, this.disable = false})
      : super(key: key);

  final BuildContext ctx;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            if (!disable) {
              Navigator.of(ctx).pop();
            }
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
