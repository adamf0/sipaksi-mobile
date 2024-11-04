import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class MultipleFileLifecycleManager with WidgetsBindingObserver {
  List<PlatformFile> selectedFiles = [];

  void init() {
    WidgetsBinding.instance.addObserver(this);
    loadSavedFiles();
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
      _clearSavedFilePaths();
    }
  }

  Future<void> loadSavedFiles() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String>? filePaths = prefs.getStringList('selectedFilePaths');

    // if (filePaths != null) {
    //   selectedFiles.clear();
    //   for (var filePath in filePaths) {
    //     if (File(filePath).existsSync()) {
    //       selectedFiles.add(PlatformFile(
    //         path: filePath,
    //         name: filePath.split('/').last,
    //         size: File(filePath).lengthSync(),
    //       ));
    //     }
    //   }
    // }
  }

  Future<void> saveFilePaths(List<String> filePaths) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setStringList('selectedFilePaths', filePaths);
    // selectedFiles = filePaths.map((path) {
    //   return PlatformFile(
    //     path: path,
    //     name: path.split('/').last,
    //     size: File(path).lengthSync(),
    //   );
    // }).toList();
  }

  Future<void> _clearSavedFilePaths() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('selectedFilePaths');
    // selectedFiles.clear(); // Clear the selected files list
  }
}
