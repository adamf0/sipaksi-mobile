import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/FileLifecycleManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/FileTypeGroup.dart';

class FileUploadExample extends StatefulWidget {
  @override
  _FileUploadExampleState createState() => _FileUploadExampleState();
}

class _FileUploadExampleState<T extends FileUploadExample> extends State<T>
    with WidgetsBindingObserver {
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  final FileLifecycleManager _fileLifecycleManager = FileLifecycleManager();

  @override
  void initState() {
    super.initState();
    _fileLifecycleManager.init();
    _fileLifecycleManager
        .loadSavedFile(); // Load saved file if available on app start
  }

  @override
  void dispose() {
    _fileLifecycleManager.dispose();
    super.dispose();
  }

  void _onProgressUpdate(double progress) {
    setState(() {
      _uploadProgress = progress;
    });
  }

  void _onUploadStart() {
    setState(() {
      _isUploading = true;
    });
  }

  void _onUploadComplete() {
    setState(() {
      _uploadProgress = 0.0;
      _isUploading = false;
      _fileLifecycleManager.selectedFile = null; // Clear selected file
    });
  }

  void _onUploadFailed() {
    setState(() {
      _isUploading = false;
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: FileTypeGroup.getExtensions([
        FileTypeGroup.image,
        FileTypeGroup.document,
      ]),
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileLifecycleManager.selectedFile = result.files.single;
      });
      await _fileLifecycleManager
          .saveFilePath(_fileLifecycleManager.selectedFile!.path!);
    }
  }

  Future<void> _uploadFile() async {
    if (_fileLifecycleManager.selectedFile != null) {
      _onUploadStart();
      try {
        // Implement your upload service here
        Dio dio = Dio();
        FormData formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
              _fileLifecycleManager.selectedFile!.path!,
              filename: _fileLifecycleManager.selectedFile!.name),
        });
        await dio.post('https://your-api-endpoint.com/upload', data: formData,
            onSendProgress: (sent, total) {
          _onProgressUpdate(sent / total);
        });
        _onUploadComplete();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('File berhasil diunggah!')));
      } catch (e) {
        _onUploadFailed();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal mengunggah file: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _fileLifecycleManager.selectedFile != null
                ? Text(
                    'File: ${_fileLifecycleManager.selectedFile!.name} (${_fileLifecycleManager.selectedFile!.size} bytes)')
                : Text('Tidak ada file yang dipilih'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pilih File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Unggah File'),
            ),
            SizedBox(height: 20),
            ProgressIndicatorWidget(
                progress: _uploadProgress, isUploading: _isUploading),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final bool isUploading;

  const ProgressIndicatorWidget({
    required this.progress,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? Column(
            children: [
              Text('Mengunggah: ${(progress * 100).toStringAsFixed(0)}%'),
              SizedBox(height: 10),
              LinearProgressIndicator(value: progress),
            ],
          )
        : Text('Tidak ada unggahan yang sedang berlangsung');
  }
}
