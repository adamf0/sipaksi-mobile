import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Components/UploadFile/BoxSelectFile.dart';
import 'package:sipaksi/Components/UploadFile/FileSelectedUpload.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/FileTypeGroup.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/Provider/LoadingSaveSubstansiState.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/SingleFileLifecycleManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/DefaultState.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sipaksi/Module/Shared/LoadingManager.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

class SubstansiPage extends StatefulWidget {
  const SubstansiPage({super.key});

  @override
  State<SubstansiPage> createState() => _SubstansiPageState();
}

class _SubstansiPageState extends State<SubstansiPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveSubstansiState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSaveSubstansiState>(context);

              return constraints.maxWidth >= 768
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => !loadingState.isLoadingSave
                          ? Navigator.of(context).pop()
                          : null,
                    );
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: Hero(
            tag: NameTimeline.step4_1.title,
            child: Text(
              NameTimeline.step4_1.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 768) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Sidebar.createSidebar(
                      context: context,
                      height: height,
                      list: ListItemsSidebar(current),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Content(
                      width: width,
                      height: height,
                    ),
                  ),
                ],
              );
            } else {
              return Content(
                width: width,
                height: height,
              );
            }
          },
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({super.key, required this.width, required this.height});

  final double width, height;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;
  final SingleFileLifecycleManager fileLifecycleManager =
      SingleFileLifecycleManager();
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

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingSaveSubstansiState>(context);
    LoadingManager loadingManager =
        LoadingManager(DefaultState(loadingState.isLoadingSave));

    return Column(
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
                      isUploading: loadingState.isLoadingSave,
                      onDelete: () {
                        setState(() {
                          loadingState.setLoading(false);
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
          isLoading: loadingManager.stateLoading,
          optionalBuilder: (height) => SizedBox.shrink(),
          onPress: (double height) async {
            if (fileLifecycleManager.selectedFile != null &&
                !loadingState.isLoadingSave) {
              setState(() {
                uploadProgress = 0.0;
                loadingState.setLoading(true);
              });
              try {
                Dio dio = Dio();
                FormData formData = FormData.fromMap({
                  'file': await MultipartFile.fromFile(
                      fileLifecycleManager.selectedFile!.path!,
                      filename: fileLifecycleManager.selectedFile!.name),
                });
                await dio.post('https://your-api-endpoint.com/upload',
                    data: formData, onSendProgress: (sent, total) {
                  setState(() {
                    uploadProgress = sent / total;
                  });
                });
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    uploadProgress = 0.0;
                    loadingState.setLoading(false);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('File berhasil diunggah!'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: height + 8,
                      ),
                    ),
                  );
                  // .closed
                  // .then((_) => Navigator.of(context).pop());
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal mengunggah file: $e')));
                setState(() {
                  uploadProgress = 0.0;
                  loadingState.setLoading(false);
                });
              }
            }
          },
        ),
      ],
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: FileTypeGroup.getExtensions([
        FileTypeGroup.image,
        FileTypeGroup.document,
      ]),
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        fileLifecycleManager.selectedFile = result.files.single;
      });
      await fileLifecycleManager
          .saveFilePath(fileLifecycleManager.selectedFile!.path!);
    }
  }
}
