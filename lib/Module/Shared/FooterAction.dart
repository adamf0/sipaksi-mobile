import 'package:flutter/material.dart';

class FooterAction extends StatelessWidget {
  const FooterAction({
    Key? key,
    required this.onPress,
    required this.optionalBuilder,
  }) : super(key: key);

  final Function(double height) onPress;
  final Widget Function(double height) optionalBuilder;

  double getWrapHeight(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.height ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    double height = getWrapHeight(context);
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          optionalBuilder(height),
          TextButton(
            onPressed: () {
              onPress(height);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
