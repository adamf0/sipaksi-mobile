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
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenPendukung/Fetch/DokumenTambahanFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenPendukung/Filter/DokumenTambahanFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenPendukung/ItemList/DokumenTambahanStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenPendukung/Provider/LoadingSaveDokumenPendukungState.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/FileTypeGroup.dart';
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

class DokumenPendukungPage extends StatefulWidget {
  const DokumenPendukungPage({super.key});

  @override
  State<DokumenPendukungPage> createState() => _DokumenPendukungPageState();
}

class _DokumenPendukungPageState extends State<DokumenPendukungPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveDokumenPendukungState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSaveDokumenPendukungState>(context);

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
            tag: NameTimeline.step6_1.title,
            child: Text(
              NameTimeline.step6_1.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 768) {
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
  bool isUpload = false;
  double uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    fileLifecycleManager.init();
    fileLifecycleManager.loadSavedFile();

    anggotaPenelitianManager = AnggotaPenelitianManager<Post>(
      DokumenTambahanFetchStrategy(),
      DokumenTambahanFilterStrategy(),
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
    final loadingState = Provider.of<LoadingSaveDokumenPendukungState>(context);
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
                    itemListStrategy: DokumenTambahanStrategy(),
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
                      setState(() {
                        loadingState.setLoading(false);
                      });
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
    String kategori = "";
    String link = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (contextSheet) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return FractionallySizedBox(
              heightFactor: 0.8,
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
                            Text(
                              "Kategori",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              onChanged: (value) {
                                setState(() {
                                  kategori = value;
                                });
                                setSheetState(() {});
                              },
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                              decoration: InputDecoration(
                                errorText:
                                    kategori.isEmpty ? "belum diisi" : null,
                                hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 1,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Link",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.url,
                              obscureText: false,
                              onChanged: (value) {
                                setState(() {
                                  link = value;
                                });
                                setSheetState(() {});
                              },
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                              decoration: InputDecoration(
                                errorText: link.isEmpty ? "belum diisi" : null,
                                hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 1,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 1,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
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
                                    link.isEmpty &&
                                            fileLifecycleManager.selectedFile ==
                                                null
                                        ? "tidak boleh kosong"
                                        : (link.isNotEmpty
                                            ? "file tidak akan dikirim"
                                            : ""),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: link.isNotEmpty
                                          ? Colors.orange
                                          : Theme.of(context).colorScheme.error,
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
                                progress: uploadProgress, //tidak terupdate
                                isUploading: isUpload, //tidak terupdate
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
                                if (!isUpload
                                    // && fileLifecycleManager.selectedFile != null
                                    ) {
                                  setState(() {
                                    isUpload = true;
                                  });
                                  setSheetState(() {});
                                  try {
                                    Dio dio = Dio();
                                    FormData formData = FormData.fromMap({});

                                    MapEntry('kategori', kategori);
                                    if (link.isNotEmpty) {
                                      formData.fields.add(
                                        MapEntry('link', link),
                                      );
                                    } else if (fileLifecycleManager
                                            .selectedFile !=
                                        null) {
                                      formData.files.add(
                                        MapEntry(
                                          'file',
                                          await MultipartFile.fromFile(
                                            fileLifecycleManager
                                                .selectedFile!.path!,
                                            filename: fileLifecycleManager
                                                .selectedFile!.name,
                                          ),
                                        ),
                                      );
                                    } else {
                                      throw new Exception(
                                          "link/file masih kosong");
                                    }

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
                                      kategori = "";
                                      link = "";
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
