import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Fetch/MahasiswaFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Filter/MahasiswaFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Provider/LoadingSaveAggotaPenelitiState.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/DefaultState.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Shared/LoadingManager.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

class AnggotaPenelitiMahasiswaMbkmPage extends StatefulWidget {
  const AnggotaPenelitiMahasiswaMbkmPage({super.key});

  @override
  State<AnggotaPenelitiMahasiswaMbkmPage> createState() =>
      _AnggotaPenelitiMahasiswaMbkmPageState();
}

class _AnggotaPenelitiMahasiswaMbkmPageState
    extends State<AnggotaPenelitiMahasiswaMbkmPage> {
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
            tag: NameTimeline.step3_2_2.title,
            child: Text(
              NameTimeline.step3_2_2.title,
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
  Map<String, String> listBuktiMbkm = {};

  @override
  void initState() {
    super.initState();
    anggotaPenelitianManager = AnggotaPenelitianManager<Post>(
      MahasiswaFetchStrategy(),
      MahasiswaFilterStrategy(),
    );

    anggotaPenelitianManager.dataFuture.then((data) {
      listBuktiMbkm = {for (var item in data) item.id.toString(): ""};
    });
  }

  String jsonData() {
    return jsonEncode(listBuktiMbkm);
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingSaveAggotaPenelitiState>(context);
    Debouncer _debouncer = Debouncer(milliseconds: 500);
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
                      return constraints.maxWidth >= 768
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
                                      title: NameTimeline.step3_2_2.title,
                                      onTap: () => {},
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
                  const SizedBox(height: 10),
                  CustomListView<Post>(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    source: anggotaPenelitianManager.dataFuture,
                    filteredData: anggotaPenelitianManager.filteredData,
                    render: (ctx, item, index) {
                      Color color =
                          Theme.of(context).colorScheme.inverseSurface;

                      return ListTile(
                        title: Text(
                          item.title ?? "-",
                          style: TextStyle(color: color),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "065117251",
                              style: TextStyle(color: color),
                            ),
                            Text(
                              "Ilmu Komputer",
                              style: TextStyle(color: color),
                            ),
                            TextField(
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              onChanged: (value) {
                                setState(() {
                                  listBuktiMbkm[item.id.toString()] = value;
                                });
                              },
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              decoration: InputDecoration(
                                errorText: (listBuktiMbkm[item.id.toString()]
                                            ?.isEmpty ??
                                        true)
                                    ? "tidak boleh kosong"
                                    : null,
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
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        FooterAction(
          isLoading: loadingManager.stateLoading,
          optionalBuilder: (height) => SizedBox.shrink(),
          onPress: (double height) {
            int totalKosong =
                listBuktiMbkm.values.where((value) => value.isEmpty).length;
            if (totalKosong > 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('masih ada $totalKosong bukti mbkm yg masih kosong'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: height + 8,
                  ),
                ),
              );
            } else if (!loadingState.isLoadingSave) {
              setState(() {
                loadingState.setLoading(true);
              });
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  loadingState.setLoading(false);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Data berhasil disimpan!'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: height + 8,
                    ),
                  ),
                );
              });
            }
            print("footerHeight: ${height.toString()}");
          },
        ),
      ],
    );
  }
}
