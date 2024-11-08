import 'package:flutter/material.dart';
import 'package:sipaksi/Components/Popmenu/PopupMenuStrategy.dart';

class PopmenuItemsFactory {
  final List<PopupMenuItem<String>> list;

  PopmenuItemsFactory({required PopupMenuStrategy startegy})
      : list = _createMenuItems(startegy);

  static List<PopupMenuItem<String>> _createMenuItems(
    PopupMenuStrategy startegy,
  ) {
    return startegy.getList();
  }

  List<PopupMenuItem<String>> get getList => list;
}

//Status.menunggu_pilih_reviewer, Status.terima