import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sipaksi/Components/CenterLoading/CenterLoadingComponent.dart';
import 'package:sipaksi/Components/Error/DataNotFoundComponent.dart';
import 'package:sipaksi/Components/Error/ErrorComponent.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Post.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';

class AnggotaPenelitiDosenPage extends StatefulWidget {
  const AnggotaPenelitiDosenPage({super.key});

  @override
  State<AnggotaPenelitiDosenPage> createState() =>
      _AnggotaPenelitiDosenPageState();
}

class _AnggotaPenelitiDosenPageState extends State<AnggotaPenelitiDosenPage> {
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
      print("AnggotaPenelitiDosenPage [getPosts](DioError): ${e.message}");
      rethrow;
    } catch (e) {
      print("AnggotaPenelitiDosenPage [getPosts](Error): $e");
      rethrow;
    }
  }

  late List<String> errorMessages = [];
  late Future<List<Post>> postsFuture;
  List<Post> allPosts = [];
  ValueNotifier<List<Post>> filteredPosts = ValueNotifier<List<Post>>([]);
  String searchTerm = "";
  List<Post?> dosenSelected = [];

  List<int?> getListSelected() {
    return dosenSelected.map<int?>((dosen) => dosen?.id).toList();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    SizedBox(height: 10),
                    FutureBuilder<List<Post>>(
                      future: postsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CenterLoadingComponent();
                        } else if (snapshot.hasError) {
                          // errorMessages.add(snapshot.error.toString());
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
                                itemCount: filteredPostsValue.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final dosen = filteredPostsValue[index];
                                  final isSelected =
                                      dosenSelected.contains(dosen);

                                  return ListTile(
                                    title: Text(
                                      dosen.title ?? "-",
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
                                    subtitle: Text(
                                      "Fakultas Hukum - Ilmu Hukum (S1)",
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
                                    trailing: Checkbox(
                                      value: isSelected,
                                      activeColor: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            dosenSelected.add(dosen);
                                          } else {
                                            dosenSelected.remove(dosen);
                                          }
                                        });
                                        print(listToJson(dosenSelected));
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
            optionalBuilder: (height) => Container(),
            onPress: (double height) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data berhasil disimpan!'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: height + 8, // Menggunakan tinggi dari FooterAction
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
