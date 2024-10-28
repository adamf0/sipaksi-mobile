import 'package:flutter/material.dart';

class CenterLoadingComponent extends StatelessWidget {
  const CenterLoadingComponent({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height == null ? MediaQuery.of(context).size.height : this.height,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
