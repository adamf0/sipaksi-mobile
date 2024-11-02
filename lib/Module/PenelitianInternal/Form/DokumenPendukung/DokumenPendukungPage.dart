import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/CloseBottomSheet.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Components/UploadFile/BoxSelectFile.dart';
import 'package:sipaksi/Components/UploadFile/FileSelectedUpload.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenPendukung/Fetch/DokumenTambahanFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenPendukung/Filter/DokumenTambahanFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenPendukung/ItemList/DokumenTambahanStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/SingleFileLifecycleManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class DokumenPendukungPage extends StatefulWidget {
  const DokumenPendukungPage({super.key});

  @override
  State<DokumenPendukungPage> createState() => _DokumenPendukungPageState();
}

class _DokumenPendukungPageState extends State<DokumenPendukungPage> {
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;
  final SingleFileLifecycleManager fileLifecycleManager =
      SingleFileLifecycleManager();
  bool isUpload = false;
  double uploadProgress = 0.0;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    fileLifecycleManager.init();
    fileLifecycleManager.loadSavedFile(); // Load saved file if available

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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => !isUpload ? Navigator.of(context).pop() : null,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Hero(
          tag: "Dokumen Pendukung",
          child:
              Text("Dokumen Pendukung", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Column(
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
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
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
                        print(
                            listToJson(anggotaPenelitianManager.selectedItems));
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
            isLoading: isLoading,
            optionalBuilder: (height) =>
                getListSelected().isNotEmpty || isLoading.value
                    ? TextButton(
                        onPressed: () {
                          !isLoading.value
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Data berhasil hapus!'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: height + 8,
                                    ),
                                  ),
                                )
                              : null;
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    : SizedBox.shrink(),
            buttonHide: true,
            onPress: (double height) {},
          ),
        ],
      ),
    );
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
              heightFactor: 1.1,
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
                                if (!isUpload) {
                                  if (fileLifecycleManager.selectedFile !=
                                      null) {
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'File berhasil diunggah!')));
                                      Navigator.of(context).pop();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Gagal mengunggah file: $e')));
                                    } finally {
                                      setState(() {
                                        isUpload = false;
                                        uploadProgress = 0.0;
                                        fileLifecycleManager.selectedFile =
                                            null;
                                        kategori = "";
                                        link = "";
                                      });
                                      setSheetState(() {});
                                    }
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
