import 'package:flutter/material.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Share/ItemListStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';

class NonDosenItemListStrategy implements ItemListStrategy<Post> {
  @override
  Widget buildTile(
    BuildContext context,
    Post data,
    bool isSelected,
    Function(Post) onSelectedChanged, //pindah ke contructor
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
            "00000000", //nomor identitas
            style: TextStyle(
              color: color,
            ),
          ),
          Text(
            "aaaaaaaa", //nama
            style: TextStyle(
              color: color,
            ),
          ),
          Text(
            "bbbbbbbb", //afiliasi
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
