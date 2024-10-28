import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownItems.dart';

class ItemsDropdownSearch extends StatelessWidget {
  const ItemsDropdownSearch({
    Key? key,
    required this.padding,
    required this.item,
  }) : super(key: key);

  final DropdownItems item;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.text,
        style: TextStyle(
            fontSize: 16.0, color: Theme.of(context).colorScheme.tertiary),
      ),
    );
  }
}
