import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/FileTypeGroup.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/MultipleFileLifecycleManager.dart';

class MultipleFileUploadExample extends StatefulWidget {
  @override
  _MultipleFileUploadExampleState createState() =>
      _MultipleFileUploadExampleState();
}

class _MultipleFileUploadExampleState extends State<MultipleFileUploadExample>
    with WidgetsBindingObserver {
  final MultipleFileLifecycleManager _fileLifecycleManager =
      MultipleFileLifecycleManager();
  List<double> _uploadProgresses = [];
  List<bool> _uploadingStates = [];

  @override
  void initState() {
    super.initState();
    _fileLifecycleManager.init();
    _uploadProgresses =
        List<double>.filled(_fileLifecycleManager.selectedFiles.length, 0.0);
    _uploadingStates =
        List<bool>.filled(_fileLifecycleManager.selectedFiles.length, false);
  }

  @override
  void dispose() {
    _fileLifecycleManager.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: FileTypeGroup.getExtensions([
        FileTypeGroup.image,
        FileTypeGroup.document,
      ]), // Add your allowed extensions
    );

    if (result != null && result.files.isNotEmpty) {
      List<String> filePaths = result.paths.whereType<String>().toList();
      await _fileLifecycleManager.saveFilePaths(filePaths);
      setState(() {
        _uploadProgresses = List<double>.filled(
            _fileLifecycleManager.selectedFiles.length, 0.0);
        _uploadingStates = List<bool>.filled(
            _fileLifecycleManager.selectedFiles.length, false);
      });
    }
  }

  Future<void> _uploadFiles() async {
    if (_fileLifecycleManager.selectedFiles.isNotEmpty) {
      List<Future<void>> uploadFutures = [];

      for (int i = 0; i < _fileLifecycleManager.selectedFiles.length; i++) {
        final file = _fileLifecycleManager.selectedFiles[i];
        uploadFutures.add(_uploadFile(file, i));
      }

      await Future.wait(uploadFutures); // Wait for all uploads to complete
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All files successfully uploaded!')));
    }
  }

  Future<void> _uploadFile(PlatformFile file, int index) async {
    _uploadingStates[index] =
        true; // Set the uploading state to true for this file
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path!, filename: file.name),
    });

    try {
      await dio.post('https://your-api-endpoint.com/upload', data: formData,
          onSendProgress: (sent, total) {
        setState(() {
          _uploadProgresses[index] =
              sent / total; // Update progress for this specific file
        });
      });
    } catch (e) {
      print('Upload failed for ${file.name}: $e');
    } finally {
      setState(() {
        _uploadingStates[index] =
            false; // Reset uploading state after completion
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concurrent File Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _fileLifecycleManager.selectedFiles.isNotEmpty
                ? Column(
                    children: List.generate(
                        _fileLifecycleManager.selectedFiles.length, (index) {
                      var file = _fileLifecycleManager.selectedFiles[index];
                      return Column(
                        children: [
                          Text('File: ${file.name} (${file.size} bytes)'),
                          LinearProgressIndicator(
                              value: _uploadProgresses[index]),
                          SizedBox(height: 10),
                          Text(_uploadingStates[index]
                              ? 'Uploading...'
                              : 'Upload Complete'),
                          SizedBox(height: 20),
                        ],
                      );
                    }),
                  )
                : Text('No files selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFiles,
              child: Text('Pick Files'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFiles,
              child: Text('Upload Files'),
            ),
          ],
        ),
      ),
    );
  }
}
