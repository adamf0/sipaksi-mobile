import 'package:flutter/material.dart';

class DataNotFoundComponent extends StatelessWidget {
  const DataNotFoundComponent({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width * 0.5,
          child: Image.asset(
            'lib/assets/images/no_data.png',
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Data tidak ditemukan",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
