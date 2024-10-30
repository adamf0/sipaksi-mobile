// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sipaksi/Components/CenterLoading/CenterLoadingComponent.dart';
import 'package:sipaksi/Components/Error/DataNotFoundComponent.dart';
import 'package:sipaksi/Components/Error/ErrorComponent.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/InternalResearchFormPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Dialog.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/ItemsPopmenu.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Post.dart';
import 'package:dio/dio.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Status.dart';

class InternalResearchCatalogPage extends StatefulWidget {
  const InternalResearchCatalogPage({super.key});

  @override
  State<InternalResearchCatalogPage> createState() =>
      _InternalResearchCatalogPageState();
}

class _InternalResearchCatalogPageState
    extends State<InternalResearchCatalogPage> {
  static Future<List<Post>> getPosts() async {
    try {
      final response = await Dio(
        BaseOptions(
          baseUrl: "https://jsonplaceholder.typicode.com",
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ),
      ).get("/albums/1/photos");

      final List body = response.data;
      return body.map((e) => Post.fromJson(e)).toList();
    } on DioError catch (e) {
      print("InternalResearchCatalogPage [getPosts](DioError): ${e.message}");
      rethrow;
    } catch (e) {
      print("InternalResearchCatalogPage [getPosts](Error): $e");
      rethrow;
    }
  }

  late List<String> errorMessages = [];
  late Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = getPosts(); // Inisialisasi future di sini
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void actionPopUpItemSelected(String value) {
    _scaffoldKey.currentState?.hideCurrentSnackBar();

    String message;
    if (value == 'edit') {
      message = 'You selected edit for ';
    } else if (value == 'delete') {
      message = 'You selected delete for ';
    } else {
      message = 'Not implemented';
    }

    final snackBar = SnackBar(content: Text(message));

    // Show the SnackBar using ScaffoldMessenger
    _scaffoldKey.currentState?.showSnackBar(snackBar);
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
          "Penelitian Internal",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: height * .1),
          child: FutureBuilder<List<Post>>(
            future: postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CenterLoadingComponent();
              } else if (snapshot.hasError) {
                // errorMessages.add(snapshot.error.toString());
                return ErrorComponent(
                  height: height,
                  errorMessage: snapshot.error.toString(),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return DataNotFoundComponent(width: width);
              } else {
                final posts = snapshot.data!;
                return ListView.builder(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ItemsListview(post: post);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ItemsListview extends StatelessWidget {
  const ItemsListview({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    Status status = Status.parse("tolak");
    PopmenuItemsFactory factory = PopmenuItemsFactory(type: status.key);
    DialogFactory dialog = DialogFactory(
      context: context,
      content: Text("Anda yakin ingin hapus penelitian '${post.title}'"),
    );

    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        right: 8,
        left: 8,
      ),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 20,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "01/12/2024",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    const InfoItemsListview(
                        title: "Nama Ketua Pengusul", value: "adam"),
                    const InfoItemsListview(title: "Fakultas", value: "MIPA"),
                    const InfoItemsListview(title: "Prodi", value: "Ilkom"),
                    InfoItemsListview(title: "Judul", value: post.title),
                    const InfoItemsListview(
                        title: "Skema",
                        value:
                            "Penelitian Kolaborasi"), //kategori / skema, factory
                    InfoItemsListview(
                      title: "Reviewer",
                      value: Text(
                        "adam dan furqon",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                    ),
                    InfoItemsListview(
                      title: "Status",
                      value: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status.value,
                            style: TextStyle(color: status.color),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (factory.getList.isNotEmpty
                ? PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return factory.getList;
                    },
                    onSelected: (String value) => {
                      if (value == "edit")
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const InternalResearchFormPage(),
                            ),
                          )
                        }
                      else if (value == "delete")
                        {dialog.showDialog("confirm_dialog")}
                      else if (value == "approve_member")
                        {}
                      else if (value == "reject_member")
                        {}
                      else if (value == "proposal")
                        {}
                      else if (value == "show_administration")
                        {}
                      else if (value == "show_substance")
                        {}
                      else if (value == "add_logbook")
                        {}
                      else if (value == "add_progress_report")
                        {}
                      else if (value == "add_final_report")
                        {}
                    },
                  )
                : Container())
          ],
        ),
      ),
    );
  }
}

class InfoItemsListview extends StatelessWidget {
  const InfoItemsListview({super.key, required this.title, this.value});

  final String title;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontFamily: 'Manrope',
              color: Colors.black),
        ),
        (value is Widget
            ? value
            : Text(
                value ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Manrope',
                    color: Theme.of(context).colorScheme.tertiary),
              )),
        const SizedBox(height: 8)
      ],
    );
  }
}
