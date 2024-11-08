import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sipaksi/Module/Abstraction/Command.dart';
import 'package:sipaksi/Components/Dialog/Dialog.dart';

class LogoutCommand implements Command {
  @override
  void execute(Map<dynamic, dynamic> params) {
    if (!params.containsKey('context')) {
      throw new Exception("paramater context belim di setup");
    }

    DialogFactory dialog = DialogFactory(
      context: params['context'],
      content: Text("Anda yakin ingin keluar?"),
      yesTap: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      noTap: () {
        Navigator.pop(params['context']);
      },
    );

    dialog.showDialog("logout_dialog");
  }
}
