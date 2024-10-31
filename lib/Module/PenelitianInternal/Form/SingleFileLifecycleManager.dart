import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleFileLifecycleManager with WidgetsBindingObserver {
  PlatformFile? selectedFile;

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  bool lifecycleHasCloseOrDestroy(AppLifecycleState state) {
    return [AppLifecycleState.detached, AppLifecycleState.inactive]
        .contains(state);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (lifecycleHasCloseOrDestroy(state)) {
      _clearSavedFilePath();
    }
  }

  Future<void> loadSavedFile() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? filePath = prefs.getString('selectedFilePath');

    // if (filePath != null && File(filePath).existsSync()) {
    //   selectedFile = PlatformFile(
    //     path: filePath,
    //     name: filePath.split('/').last,
    //     size: File(filePath).lengthSync(),
    //   );
    // }
  }

  Future<void> saveFilePath(String filePath) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('selectedFilePath', filePath);
  }

  Future<void> _clearSavedFilePath() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('selectedFilePath');
  }
}
