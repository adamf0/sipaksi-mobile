import 'package:flutter/material.dart';

class LoadingSaveDokumenKontrakState with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoadingSave => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
