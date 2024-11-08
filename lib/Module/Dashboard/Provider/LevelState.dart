import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelState with ChangeNotifier {
  LevelState(this._level) {
    _loadLevel();
  }

  String _level = "-";

  String get level => _level;

  Future<void> setLevel(String value) async {
    _level = value;
    await _saveLevel();
    notifyListeners();
  }

  Future<void> _loadLevel() async {
    final prefs = await SharedPreferences.getInstance();
    _level = prefs.getString('level') ?? '-';
    notifyListeners();
  }

  Future<void> _saveLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('level', _level);
  }
}
