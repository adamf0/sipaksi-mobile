import 'package:flutter/material.dart';

class CloseBottomSheet extends StatelessWidget {
  const CloseBottomSheet({Key? key, required this.ctx}) : super(key: key);

  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
