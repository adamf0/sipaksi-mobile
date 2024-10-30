import 'package:flutter/material.dart';

abstract class ItemListStrategy<T> {
  Widget buildTile(
    BuildContext context,
    T data,
    bool isSelected,
    Function(T) onSelectedChanged,
  );
}
