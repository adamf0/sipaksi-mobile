import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

class ItemStepCreadCrumb {
  final IconData? icon;
  final String? title;
  final VoidCallback onTap;

  ItemStepCreadCrumb({this.icon, this.title, required this.onTap});
}

class StepBreadCrumb {
  static BreadCrumb createBreadCrumb(
      {required BuildContext context, required List<ItemStepCreadCrumb> list}) {
    return BreadCrumb(
      items: list.map((item) {
        return BreadCrumbItem(
          content: item.title == null
              ? InkWell(
                  onTap: item.onTap,
                  child: Icon(
                    item.icon ?? Icons.home,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Text(
                  item.title ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Manrope',
                    color: Colors.black,
                  ),
                ),
          onTap: item.onTap,
        );
      }).toList(),
      divider: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.outline,
      ),
      overflow: ScrollableOverflow(
        direction: Axis.horizontal,
        keepLastDivider: false,
        controller: ScrollController(),
      ),
    );
  }
}
