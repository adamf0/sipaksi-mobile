import 'package:flutter/material.dart';
import 'package:sipaksi/Module/Abstraction/Command.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Dialog.dart';

class DeleteCommand implements Command {
  @override
  void execute(Map<dynamic, dynamic> params) {
    if (!params.containsKey('context')) {
      throw new Exception("paramater context belim di setup");
    }
    if (!params.containsKey('title')) {
      throw new Exception("paramater title belim di setup");
    }

    DialogFactory dialog = DialogFactory(
      context: params['context'],
      content: Text("Anda yakin ingin hapus penelitian '${params['title']}'"),
    );
    dialog.showDialog("confirm_dialog");
  }
}
