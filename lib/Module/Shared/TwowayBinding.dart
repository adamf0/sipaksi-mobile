import 'package:flutter/material.dart';
import 'package:sipaksi/Module/Shared/LoadingStrategy.dart';

class TwoWayBinding implements LoadingStrategy<ValueNotifier<bool>> {
  final ValueNotifier<bool> param;

  TwoWayBinding(this.param);

  @override
  bool output() {
    return param.value;
  }
}
