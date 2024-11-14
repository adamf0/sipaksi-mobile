import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/DropdownSearch/CloseBottomSheet.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Components/UploadFile/BoxSelectFile.dart';
import 'package:sipaksi/Components/UploadFile/FileSelectedUpload.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenKontrak/Provider/LoadingSaveDokumenKontrakState.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/FileTypeGroup.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/Fetch/LuaranTambahanFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/Filter/LuaranFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/ItemList/LuaranStrategy.dart';
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

class DokumenKontrakPage extends StatefulWidget {
  const DokumenKontrakPage({super.key});

  @override
  State<DokumenKontrakPage> createState() => _DokumenKontrakPageState();
}

class _DokumenKontrakPageState extends State<DokumenKontrakPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveDokumenKontrakState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSaveDokumenKontrakState>(context);

              return constraints.maxWidth >= 540
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
          title: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth >= 540
                ? SizedBox.shrink()
                : Text(
                    NameTimeline.step7_1.title,
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 540) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Sidebar.createSidebar(
                      context: context,
                      height: height,
                      list: ListItemsSidebar(context, current),
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
  bool isUpload = false;
  double uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    fileLifecycleManager.init();
    fileLifecycleManager.loadSavedFile(); // Load saved file if available

    anggotaPenelitianManager = AnggotaPenelitianManager<Post>(
      LuaranTambahanFetchStrategy(),
      LuaranFilterStrategy(),
    );
  }

  @override
  void dispose() {
    fileLifecycleManager.dispose();
    super.dispose();
  }

  List<int?> getListSelected() {
    return anggotaPenelitianManager.selectedItems
        .map<int?>((dosen) => dosen?.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Debouncer _debouncer = Debouncer(milliseconds: 500);
    final loadingState = Provider.of<LoadingSaveDokumenKontrakState>(context);
    LoadingManager loadingManager =
        LoadingManager(DefaultState(loadingState.isLoadingSave));

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Search(
                    onChange: (term) => _debouncer.run(() {
                      anggotaPenelitianManager.updateSearchTerm(term);
                    }),
                  ),
                  Wrap(
                    children: [
                      TextButton(
                        onPressed: () {
                          _showBottomSheet(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Tambah Data',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomListView<Post>(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    source: anggotaPenelitianManager.dataFuture,
                    filteredData: anggotaPenelitianManager.filteredData,
                    onSelectedChanged: (post) {
                      setState(() {
                        if (anggotaPenelitianManager.selectedItems
                            .contains(post)) {
                          anggotaPenelitianManager.selectedItems.remove(post);
                        } else {
                          anggotaPenelitianManager.selectedItems.add(post);
                        }
                      });
                      print(listToJson(anggotaPenelitianManager.selectedItems));
                    },
                    selectedItems: anggotaPenelitianManager.selectedItems,
                    itemListStrategy: LuaranStrategy(),
                  )
                ],
              ),
            ),
          ),
        ),
        FooterAction(
          isLoading: loadingManager.stateLoading,
          optionalBuilder: (height) {
            if (loadingManager.stateLoading) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              );
            } else if (!loadingManager.stateLoading &&
                getListSelected().isNotEmpty) {
              return TextButton(
                onPressed: () {
                  if (!loadingManager.stateLoading) {
                    setState(() {
                      loadingState.setLoading(true);
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Data berhasil dihapus!'),
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
                      setState(() {
                        loadingState.setLoading(false);
                      });
                    });
                  }
                  // print("footerHeight: ${height.toString()}");
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text(
                  'Hapus',
                  style: TextStyle(fontSize: 14),
                ),
              );
            }

            return SizedBox.shrink();
          },
          buttonHide: true,
          onPress: (double height) {},
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

  Future<void> _showBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (contextSheet) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return FractionallySizedBox(
              heightFactor: 1.0,
              widthFactor: 1.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    CloseBottomSheet(
                      ctx: contextSheet,
                      // disable: !isUpload,
                    ),
                    Expanded(
                      child: Container(
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
                                    color: Theme.of(context).primaryColor,
                                  ),
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
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            BoxSelectFile(onSelect: () async {
                              await pickFile();
                              setSheetState(() {});
                            }),
                            SizedBox(height: 10),
                            if (fileLifecycleManager.selectedFile != null)
                              FileSelectedUpload(
                                file: fileLifecycleManager.selectedFile!,
                                progress: uploadProgress,
                                isUploading: isUpload,
                                onDelete: () {
                                  setState(() {
                                    isUpload = false;
                                    uploadProgress = 0.0;
                                    fileLifecycleManager.selectedFile = null;
                                  });
                                  setSheetState(() {});
                                },
                              ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () async {
                                if (!isUpload &&
                                    fileLifecycleManager.selectedFile != null) {
                                  setState(() {
                                    isUpload = true;
                                  });
                                  setSheetState(() {});

                                  try {
                                    Dio dio = Dio();
                                    FormData formData = FormData.fromMap({
                                      'file': await MultipartFile.fromFile(
                                          fileLifecycleManager
                                              .selectedFile!.path!,
                                          filename: fileLifecycleManager
                                              .selectedFile!.name),
                                    });
                                    await dio.post(
                                        'https://your-api-endpoint.com/upload',
                                        data: formData,
                                        onSendProgress: (sent, total) {
                                      setState(() {
                                        uploadProgress = sent / total;
                                      });
                                      setSheetState(() {});
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'File berhasil diunggah!')));
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Gagal mengunggah file: $e')));
                                  } finally {
                                    setState(() {
                                      isUpload = false;
                                      uploadProgress = 0.0;
                                      fileLifecycleManager.selectedFile = null;
                                    });
                                    setSheetState(() {});
                                  }
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 37, 112, 39),
                              ),
                              child: const Text(
                                'Simpan Data',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
