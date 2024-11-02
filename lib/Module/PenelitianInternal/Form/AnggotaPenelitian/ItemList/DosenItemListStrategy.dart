import 'package:flutter/material.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Share/ItemListStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';

class DosenItemListStrategy implements ItemListStrategy<Post> {
  @override
  Widget buildTile(
    BuildContext context,
    Post data,
    bool isSelected,
    Function(Post) onSelectedChanged,
  ) {
    Color color = isSelected
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.onSurface;

    return ListTile(
      title: Text(
        data.title ?? "-",
        style: TextStyle(
          color: color,
        ),
      ),
      subtitle: Text(
        "Fakultas Hukum - Ilmu Hukum (S1)",
        style: TextStyle(
          color: color,
        ),
      ),
      trailing: Checkbox(
        value: isSelected,
        activeColor: Theme.of(context).colorScheme.tertiary,
        onChanged: (bool? value) {
          if (value != null) {
            onSelectedChanged(data);
          }
        },
      ),
    );
  }
}
