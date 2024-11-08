import 'package:flutter/material.dart';
import 'package:sipaksi/Module/Abstraction/Command.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/InternalResearchFormPage.dart';

class BukaCommand implements Command {
  @override
  void execute(Map<dynamic, dynamic> params) {
    if (!params.containsKey('context')) {
      throw new Exception("paramater context belim di setup");
    }

    Navigator.of(params['context']).push(
      MaterialPageRoute(
        builder: (context) => const InternalResearchFormPage(),
      ),
    );
  }
}
