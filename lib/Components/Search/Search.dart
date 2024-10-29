import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key, required this.onChange});

  final Function(String term) onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: this.onChange,
      decoration: InputDecoration(
        hintText: "Search",
        border: OutlineInputBorder(),
      ),
    );
  }
}
