import 'package:flutter/material.dart';

class SmallCircleNotification extends StatelessWidget {
  const SmallCircleNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}
