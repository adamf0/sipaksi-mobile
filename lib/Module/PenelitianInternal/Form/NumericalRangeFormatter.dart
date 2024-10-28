import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double? max;

  NumericalRangeFormatter({this.min = 0, this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final double? newValueAsDouble = double.tryParse(newValue.text);

    if (newValueAsDouble == null) {
      return oldValue;
    }

    if (newValueAsDouble < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    }

    if (max != null && newValueAsDouble > max!) {
      return oldValue;
    }

    return newValue;
  }
}
