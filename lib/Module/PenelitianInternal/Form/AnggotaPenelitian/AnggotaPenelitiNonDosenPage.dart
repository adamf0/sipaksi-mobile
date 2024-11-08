import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Components/CenterLoading/CenterLoadingComponent.dart';
import 'package:sipaksi/Components/DropdownSearch/CloseBottomSheet.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Fetch/NonDosenFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Filter/NonDosenFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/ItemList/NonDosenItemListStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Provider/LoadingSaveAggotaPenelitiState.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/DefaultState.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';
import 'package:sipaksi/Module/Shared/LoadingManager.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

//masih gagal di satte bedain state hapus dan simpan
class AnggotaPenelitiNonDosenPage extends StatefulWidget {
  const AnggotaPenelitiNonDosenPage({super.key});

  @override
  State<AnggotaPenelitiNonDosenPage> createState() =>
      _AnggotaPenelitiNonDosenPageState();
}

class _AnggotaPenelitiNonDosenPageState
    extends State<AnggotaPenelitiNonDosenPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveAggotaPenelitiState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSaveAggotaPenelitiState>(context);

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
          title: Text(
            NameTimeline.step3_3.title,
            style: TextStyle(color: Colors.white),
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
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  List<int?> getListSelected() {
    return anggotaPenelitianManager.selectedItems
        .map<int?>((dosen) => dosen?.id)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    anggotaPenelitianManager = AnggotaPenelitianManager<Post>(
      NonDosenFetchStrategy(),
      NonDosenFilterStrategy(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Debouncer _debouncer = Debouncer(milliseconds: 500);
    final loadingState = Provider.of<LoadingSaveAggotaPenelitiState>(context);
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return constraints.maxWidth >= 540
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                vertical: widget.height * 0.02,
                              ),
                              child: StepBreadCrumb.createBreadCrumb(
                                  context: context,
                                  list: [
                                    ItemStepCreadCrumb(
                                      icon: Icons.home,
                                      onTap: () => Navigator.of(context)
                                        ..pop()
                                        ..pop()
                                        ..pop(),
                                    ),
                                    ItemStepCreadCrumb(
                                      title: Module.penelitian_internal.value,
                                      onTap: () => Navigator.of(context)
                                        ..pop()
                                        ..pop(),
                                    ),
                                    ItemStepCreadCrumb(
                                      title: "Form Pengajuan",
                                      onTap: () => Navigator.of(context).pop(),
                                    ),
                                    ItemStepCreadCrumb(
                                      title: NameTimeline.step3_3.title,
                                      onTap: null,
                                    ),
                                  ]),
                            )
                          : SizedBox.shrink();
                    },
                  ),
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
                    source: anggotaPenelitianManager
                        .dataFuture, //wajib dari interface
                    filteredData: anggotaPenelitianManager
                        .filteredData, //wajib dari interface
                    onSelectedChanged: (post) {
                      //harus di refactor lagi
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
                    itemListStrategy:
                        NonDosenItemListStrategy(), //onSelectedChanged harusnya ada disini agar tidak terjadi coupling dan kaya opsional function/interface di bagian render item
                  )
                ],
              ),
            ),
          ),
        ),
        FooterAction(
          isLoading: loadingManager.stateLoading,
          optionalBuilder: (height) {
            if (loadingState.isLoadingSave) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              );
            } else if (!loadingState.isLoadingSave &&
                getListSelected().isNotEmpty) {
              return TextButton(
                onPressed: () {
                  if (!loadingState.isLoadingSave) {
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
}

Future<void> postData() async {
  Dio _dio = Dio(BaseOptions(
    baseUrl: "https://jsonplaceholder.typicode.com",
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  ));

  try {
    final response = await _dio.get("/albums/1/photos");
    final List body = response.data;
  } on DioException catch (e) {
    print("Error fetching posts: ${e.message}");
    rethrow;
  } catch (e) {
    print("Unexpected error: $e");
    rethrow;
  }
}

Future<void> _showBottomSheet(BuildContext context) async {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (contextSheet) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            widthFactor: 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, loading, child) {
                  return loading
                      ? CenterLoadingComponent()
                      : Column(
                          children: [
                            CloseBottomSheet(ctx: contextSheet),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nomor Identitas",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      onChanged: (value) => {},
                                      textInputAction: TextInputAction.next,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                      decoration: InputDecoration(
                                        errorText: "belum diisi",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 6),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              width: 1),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 1),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Nama Lengkap",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      onChanged: (value) => {},
                                      textInputAction: TextInputAction.next,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                      decoration: InputDecoration(
                                        errorText: "belum diisi",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 6),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              width: 1),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 1),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Afiliasi",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      obscureText: false,
                                      onChanged: (value) => {},
                                      textInputAction: TextInputAction.next,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                      decoration: InputDecoration(
                                        errorText: "belum diisi",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 6),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                              width: 1),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 1),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              width: 2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isLoading.value = true;
                                        });

                                        postData().then((_) {
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            setState(() {
                                              isLoading.value = false;
                                            });
                                            Navigator.of(contextSheet).pop();
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            isLoading.value = false;
                                          });
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 37, 112, 39),
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
                            )
                          ],
                        );
                },
              ),
            ),
          );
        },
      );
    },
  );

  //masih gagal deteksi masih terbuka atau tidak si modalnya
  // if (result != null) {
  //   print("modal dibuka");
  // } else {
  //   print("modal ditutup");
  //   _focusNode.unfocus();
  // }
}
