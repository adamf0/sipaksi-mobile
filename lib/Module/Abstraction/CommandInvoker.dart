import 'package:sipaksi/Module/Abstraction/Command.dart';

class CommandInvoker {
  final Map<String, Command> _commands;

  CommandInvoker(this._commands);

  void executeCommand(String value, {Map<String, dynamic>? params}) {
    final command = _commands[value];
    if (command != null) {
      command.execute(params ?? {});
    } else {
      throw new Exception("command $value tidak ditemukan");
    }
  }
}

// final commandInvoker = CommandInvoker({
//   "edit": EditCommand(),
//   "delete": DeleteCommand(),
//   "approve_member": ApproveMemberCommand(),
//   "reject_member": RejectMemberCommand(),
// });

// // Usage
// commandInvoker.executeCommand(value, context, params: {
//   'someKey': 'someValue',
// });