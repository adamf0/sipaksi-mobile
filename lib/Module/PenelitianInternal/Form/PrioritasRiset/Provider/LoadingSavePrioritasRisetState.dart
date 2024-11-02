import 'package:flutter/material.dart';

class LoadingSavePrioritasRisetState with ChangeNotifier {
  ValueNotifier<bool> _isLoading = ValueNotifier(false);

  ValueNotifier<bool> get isLoadingSave => _isLoading;

  void setLoading(bool loading) {
    _isLoading.value = loading;
    notifyListeners();
  }
}
