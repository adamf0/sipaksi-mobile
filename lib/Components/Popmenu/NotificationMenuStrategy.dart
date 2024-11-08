import 'package:flutter/material.dart';
import 'package:sipaksi/Components/Popmenu/PopupMenuStrategy.dart';

class NotificationMenuStrategy implements PopupMenuStrategy {
  @override
  List<PopupMenuItem<String>> getList() {
    return [
      const PopupMenuItem(value: 'buka', child: Text('Buka')),
    ];
  }
}
