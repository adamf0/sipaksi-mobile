import 'package:flutter/material.dart';

class ItemsTimeline {
  dynamic title;
  String? description;
  bool isDone = false;
  bool required = false;
  VoidCallback? action;
  List<ItemsTimeline> subItems;

  ItemsTimeline({
    this.title,
    this.description,
    this.isDone = false,
    this.required = false,
    this.action,
    required this.subItems,
  });
}
