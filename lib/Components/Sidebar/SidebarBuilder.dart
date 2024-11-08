import 'package:flutter/material.dart';

class ItemSidebar {
  final String title;
  final bool active;
  final VoidCallback onTap;

  ItemSidebar({required this.title, this.active = false, required this.onTap});
}

class Sidebar {
  static Container createSidebar({
    required BuildContext context,
    required double height,
    required List<ItemSidebar> list,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: list
            .map((item) => ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope',
                      color: item.active
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black,
                    ),
                  ),
                  onTap: item.onTap,
                ))
            .toList(),
      ),
    );
  }
}
