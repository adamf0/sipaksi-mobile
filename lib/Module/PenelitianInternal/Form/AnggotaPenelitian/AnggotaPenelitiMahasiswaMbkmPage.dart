import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Fetch/MahasiswaFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Filter/MahasiswaFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Post.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';

class AnggotaPenelitiMahasiswaMbkmPage extends StatefulWidget {
  const AnggotaPenelitiMahasiswaMbkmPage({super.key});

  @override
  State<AnggotaPenelitiMahasiswaMbkmPage> createState() =>
      _AnggotaPenelitiMahasiswaMbkmPageState();
}

class _AnggotaPenelitiMahasiswaMbkmPageState
    extends State<AnggotaPenelitiMahasiswaMbkmPage> {
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
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
    Debouncer _debouncer = Debouncer(milliseconds: 500);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () =>
              !isLoading.value ? Navigator.of(context).pop() : null,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Anggota Penelitian (Mahasiswa)",
          style: TextStyle(color: Colors.white),
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
                                "065117251", // You might want to make this dynamic
                                style: TextStyle(color: color),
                              ),
                              Text(
                                "Ilmu Komputer", // You might want to make this dynamic
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
                                    color:
                                        Theme.of(context).colorScheme.outline,
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
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.error,
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
            isLoading: isLoading,
            optionalBuilder: (height) => Container(),
            onPress: (double height) {
              int totalKosong =
                  listBuktiMbkm.values.where((value) => value.isEmpty).length;
              if (totalKosong > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'masih ada $totalKosong bukti mbkm yg masih kosong'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: height + 8,
                    ),
                  ),
                );
              } else if (!isLoading.value) {
                isLoading.value = true;
                Future.delayed(const Duration(seconds: 2), () {
                  isLoading.value = false;
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
      ),
    );
  }
}
