import 'package:flutter/material.dart';
import 'package:sipaksi/Components/UploadFile/BoxSelectFile.dart';
import 'package:sipaksi/Components/UploadFile/FileSelectedUpload.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/SingleFileLifecycleManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Post.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class SubstansiPage extends StatefulWidget {
  const SubstansiPage({super.key});

  @override
  State<SubstansiPage> createState() => _SubstansiPageState();
}

class _SubstansiPageState extends State<SubstansiPage> {
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;
  final SingleFileLifecycleManager fileLifecycleManager =
      SingleFileLifecycleManager();
  bool isLoading = false;
  double uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    fileLifecycleManager.init();
    fileLifecycleManager.loadSavedFile(); // Load saved file if available
  }

  @override
  void dispose() {
    fileLifecycleManager.dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        fileLifecycleManager.selectedFile = result.files.single;
      });
      await fileLifecycleManager
          .saveFilePath(fileLifecycleManager.selectedFile!.path!);
    }
  }

  Future<void> uploadFile() async {
    if (fileLifecycleManager.selectedFile != null) {
      setState(() {
        isLoading = true;
      });
      try {
        Dio dio = Dio();
        FormData formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
              fileLifecycleManager.selectedFile!.path!,
              filename: fileLifecycleManager.selectedFile!.name),
        });
        await dio.post('https://your-api-endpoint.com/upload', data: formData,
            onSendProgress: (sent, total) {
          setState(() {
            uploadProgress = sent / total;
          });
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('File berhasil diunggah!')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal mengunggah file: $e')));
      } finally {
        setState(() {
          isLoading = false;
          uploadProgress = 0.0;
          // fileLifecycleManager.selectedFile = null; // Clear selected file
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => !isLoading ? Navigator.of(context).pop() : null,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Hero(
          tag: "Unggah Proposal Penelitian",
          child: Text("Unggah Proposal Penelitian",
              style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Unggah File",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).primaryColor),
                        ),
                        Expanded(
                          child: Text(
                            fileLifecycleManager.selectedFile == null
                                ? "tidak boleh kosong"
                                : "",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    BoxSelectFile(onSelect: pickFile),
                    SizedBox(height: 10),
                    if (fileLifecycleManager.selectedFile != null)
                      FileSelectedUpload(
                        file: fileLifecycleManager.selectedFile!,
                        progress: uploadProgress,
                        isUploading: isLoading,
                        onDelete: () {
                          setState(() {
                            isLoading = false;
                            uploadProgress = 0.0;
                            fileLifecycleManager.selectedFile = null;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          FooterAction(
            isLoading: ValueNotifier(isLoading),
            optionalBuilder: (height) => Container(),
            onPress: (double height) {
              if (!isLoading) {
                uploadFile();
              }
            },
          ),
        ],
      ),
    );
  }
}
