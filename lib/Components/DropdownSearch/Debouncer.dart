import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action; // Make action nullable
  Timer? _timer; // Make _timer nullable

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    // Cancel the previous timer if it exists
    _timer?.cancel(); // Use null-aware operator to cancel if _timer is not null
    // Create a new timer
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
