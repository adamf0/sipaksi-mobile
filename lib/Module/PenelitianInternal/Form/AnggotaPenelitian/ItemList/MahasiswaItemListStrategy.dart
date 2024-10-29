import 'package:flutter/material.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/ItemList/ItemListStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Post.dart';

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
        data.title ?? "-", //nama
        style: TextStyle(
          color: color,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "065117251",
            style: TextStyle(
              color: color,
            ),
          ),
          Text(
            "ilmu komputer",
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
      trailing: Checkbox(
        value: isSelected,
        activeColor: Theme.of(context).colorScheme.tertiary,
        onChanged: (bool? value) {
          onSelectedChanged(data);
        },
      ),
    );
  }
}