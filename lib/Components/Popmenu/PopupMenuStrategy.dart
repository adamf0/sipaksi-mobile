import 'package:flutter/material.dart';

abstract class PopupMenuStrategy {
  List<PopupMenuItem<String>> getList();
}
