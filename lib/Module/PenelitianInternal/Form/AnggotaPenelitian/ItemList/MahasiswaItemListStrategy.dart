import 'package:flutter/material.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Share/ItemListStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';

class MahasiswaItemListStrategy implements ItemListStrategy<Post> {
  @override
  Widget buildTile(
    BuildContext context,
    Post data,
    bool isSelected,
    Function(Post) onSelectedChanged,
  ) {
    Color color = isSelected
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.inverseSurface;

    return ListTile(
      title: Text(
        data.title ?? "-",
        style: TextStyle(color: color),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "065117251", // You might want to make this dynamic
            style: TextStyle(color: color),
          ),
          Text(
            "Ilmu Komputer", // You might want to make this dynamic
            style: TextStyle(color: color),
          ),
        ],
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
