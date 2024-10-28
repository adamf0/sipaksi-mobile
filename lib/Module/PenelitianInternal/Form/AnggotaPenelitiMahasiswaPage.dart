import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sipaksi/Components/CenterLoading/CenterLoadingComponent.dart';
import 'package:sipaksi/Components/DropdownSearch/CloseBottomSheet.dart';
import 'package:sipaksi/Components/Error/DataNotFoundComponent.dart';
import 'package:sipaksi/Components/Error/ErrorComponent.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Post.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';

class AnggotaPenelitiMahasiswaPage extends StatefulWidget {
  const AnggotaPenelitiMahasiswaPage({super.key});

  @override
  State<AnggotaPenelitiMahasiswaPage> createState() =>
      _AnggotaPenelitiMahasiswaPageState();
}

class _AnggotaPenelitiMahasiswaPageState
    extends State<AnggotaPenelitiMahasiswaPage> {
  static Future<List<Post>> getPosts() async {
    try {
      final response = await Dio(
        BaseOptions(
          baseUrl: "https://jsonplaceholder.typicode.com",
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      ).get("/albums/1/photos");

      final List body = response.data;
      return body.map((e) => Post().fromJson(e)).toList();
    } on DioException catch (e) {
      print("AnggotaPenelitiMahasiswaPage [getPosts](DioError): ${e.message}");
      rethrow;
    } catch (e) {
      print("AnggotaPenelitiMahasiswaPage [getPosts](Error): $e");
      rethrow;
    }
  }

  late List<String> errorMessages = [];
  late Future<List<Post>> postsFuture; //ambil data mahasiswa yg di pilih
  List<Post> allPosts = [];
  ValueNotifier<List<Post>> filteredPosts = ValueNotifier<List<Post>>([]);
  String searchTerm = "";
  List<Post?> mahasiswaSelected = [];

  List<int?> getListSelected() {
    return mahasiswaSelected.map<int?>((dosen) => dosen?.id).toList();
  }

  @override
  void initState() {
    super.initState();
    postsFuture = getPosts().then((posts) {
      allPosts = posts;
      filteredPosts.value = posts;
      return posts;
    });
  }

  void updateSearchTerm(String term) {
    searchTerm = term;
    final lowerCaseTerm = term.toLowerCase();
    filteredPosts.value = allPosts.where((post) {
      return (post.albumId?.toString().contains(lowerCaseTerm) ?? false) ||
          (post.id?.toString().contains(lowerCaseTerm) ?? false) ||
          (post.title?.toLowerCase().contains(lowerCaseTerm) ?? false) ||
          (post.url?.toLowerCase().contains(lowerCaseTerm) ?? false) ||
          (post.thumbnailUrl?.toLowerCase().contains(lowerCaseTerm) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Form Penelitian Internal",
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
                    TextField(
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      onChanged: updateSearchTerm,
                      textInputAction: TextInputAction.search,
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1),
                        ),
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     _showBottomSheet(context);
                    //   },
                    //   style: TextButton.styleFrom(
                    //     foregroundColor: Theme.of(context).colorScheme.error,
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Icon(
                    //         Icons.add,
                    //         color: Theme.of(context).colorScheme.primary,
                    //       ),
                    //       SizedBox(width: 10),
                    //       Text(
                    //         'Tambah Mahasiswa',
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           color: Theme.of(context).colorScheme.primary,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    FutureBuilder<List<Post>>(
                      future: postsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CenterLoadingComponent();
                        } else if (snapshot.hasError) {
                          return ErrorComponent(
                            height: height,
                            errorMessage: snapshot.error.toString(),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return DataNotFoundComponent(width: width);
                        } else {
                          return ValueListenableBuilder<List<Post>>(
                            valueListenable: filteredPosts,
                            builder: (context, filteredPostsValue, child) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredPostsValue.length,
                                itemBuilder: (context, index) {
                                  final dosen = filteredPostsValue[index];
                                  final isSelected =
                                      mahasiswaSelected.contains(dosen);

                                  return ListTile(
                                    title: Text(
                                      dosen.title ?? "-", //nama
                                      style: TextStyle(
                                        color:
                                            getListSelected().contains(dosen.id)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .tertiary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "065117251",
                                          style: TextStyle(
                                            color: getListSelected()
                                                    .contains(dosen.id)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .tertiary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface,
                                          ),
                                        ),
                                        Text(
                                          "ilmu komputer",
                                          style: TextStyle(
                                            color: getListSelected()
                                                    .contains(dosen.id)
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .tertiary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                    leading: Checkbox(
                                      value: isSelected,
                                      activeColor: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            mahasiswaSelected.add(dosen);
                                          } else {
                                            mahasiswaSelected.remove(dosen);
                                          }
                                        });
                                        print(listToJson(mahasiswaSelected));
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          FooterAction(
            optionalBuilder: (height) => mahasiswaSelected.isNotEmpty
                ? TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
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
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                : Container(),
            onPress: (double height) {
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
            },
          ),
        ],
      ),
    );
  }

  // Future<void> _showBottomSheet(BuildContext context) async {
  //   await showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (contextSheet) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.5,
  //         widthFactor: 1.0,
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: Column(
  //             children: [
  //               CloseBottomSheet(ctx: contextSheet),
  //               Expanded(
  //                 child: Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Matakuliah",
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w900,
  //                           color: Theme.of(context).primaryColor,
  //                         ),
  //                       ),
  //                       TextField(
  //                         keyboardType: TextInputType.text,
  //                         obscureText: false,
  //                         onChanged: (value) => {},
  //                         textInputAction: TextInputAction.next,
  //                         maxLines: 1,
  //                         style: TextStyle(
  //                             color: Theme.of(context).colorScheme.outline),
  //                         decoration: InputDecoration(
  //                           errorText: "belum diisi",
  //                           hintStyle: TextStyle(
  //                               color: Theme.of(context).colorScheme.outline),
  //                           contentPadding:
  //                               const EdgeInsets.symmetric(horizontal: 6),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).colorScheme.outline,
  //                                 width: 1),
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).primaryColor,
  //                                 width: 2),
  //                           ),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).colorScheme.outline,
  //                                 width: 1),
  //                           ),
  //                           errorBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).colorScheme.error,
  //                                 width: 1),
  //                           ),
  //                           focusedErrorBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).colorScheme.error,
  //                                 width: 2),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         "Total SKS",
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w900,
  //                           color: Theme.of(context).primaryColor,
  //                         ),
  //                       ),
  //                       TextField(
  //                         keyboardType: TextInputType.number,
  //                         obscureText: false,
  //                         onChanged: (value) => {},
  //                         textInputAction: TextInputAction.next,
  //                         maxLines: 1,
  //                         style: TextStyle(
  //                             color: Theme.of(context).colorScheme.outline),
  //                         decoration: InputDecoration(
  //                           errorText: "belum diisi",
  //                           hintStyle: TextStyle(
  //                               color: Theme.of(context).colorScheme.outline),
  //                           contentPadding:
  //                               const EdgeInsets.symmetric(horizontal: 6),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).colorScheme.outline,
  //                                 width: 1),
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).primaryColor,
  //                                 width: 2),
  //                           ),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).colorScheme.outline,
  //                                 width: 1),
  //                           ),
  //                           errorBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).colorScheme.error,
  //                                 width: 1),
  //                           ),
  //                           focusedErrorBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                             borderSide: BorderSide(
  //                                 color: Theme.of(context).colorScheme.error,
  //                                 width: 2),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         "File Bukti",
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w900,
  //                           color: Theme.of(context).primaryColor,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   //masih gagal deteksi masih terbuka atau tidak si modalnya
  //   // if (result != null) {
  //   //   print("modal dibuka");
  //   // } else {
  //   //   print("modal ditutup");
  //   //   _focusNode.unfocus();
  //   // }
  // }
}
