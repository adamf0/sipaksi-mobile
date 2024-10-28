import 'dart:convert';

import 'package:sipaksi/Module/Abstraction/JsonSerializable.dart';

String listToJson<T extends JsonSerializable>(List<T?> items) {
  final jsonList = items.whereType<T>().map((item) => item.toJson()).toList();
  return json.encode(jsonList);
}
