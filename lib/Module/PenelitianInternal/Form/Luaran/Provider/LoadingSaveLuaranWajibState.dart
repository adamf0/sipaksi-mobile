import 'package:flutter/material.dart';

class LoadingSaveLuaranWajibState with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoadingSave => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
