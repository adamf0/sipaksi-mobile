// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sipaksi/Components/CenterLoading/CenterLoadingComponent.dart';
import 'package:sipaksi/Components/Error/DataNotFoundComponent.dart';
import 'package:sipaksi/Components/Error/ErrorComponent.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/Abstraction/CommandInvoker.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Event/BukaCommand.dart';
import 'package:sipaksi/Components/Popmenu/ItemsPopmenu.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:dio/dio.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Components/Popmenu/NotificationMenuStrategy.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
      print("NotificationPage [getPosts](DioError): ${e.message}");
      rethrow;
    } catch (e) {
      print("NotificationPage [getPosts](Error): $e");
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

  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth >= 540
                ? SizedBox.shrink()
                : IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  );
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          Module.notifikasi.value,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Content(height: height, width: width, postsFuture: postsFuture),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.height,
    required this.width,
    required this.postsFuture,
  });

  final double height;
  final double width;
  final Future<List<Post>> postsFuture;

  @override
  Widget build(BuildContext context) {
    Module current = Module.notifikasi;

    return LayoutBuilder(
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: width * .01,
                          right: width * .01,
                          top: 10,
                        ),
                        child: StepBreadCrumb.createBreadCrumb(
                            context: context,
                            list: [
                              ItemStepCreadCrumb(
                                icon: Icons.home,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              ItemStepCreadCrumb(
                                title: Module.notifikasi.value,
                                onTap: null,
                              )
                            ]),
                      ),
                      ListNotification(
                        height: height,
                        width: width,
                        sourceFuture: postsFuture,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            child: ListNotification(
              height: height,
              width: width,
              sourceFuture: postsFuture,
            ),
          );
        }
      },
    );
  }
}

class ListNotification extends StatelessWidget {
  const ListNotification({
    super.key,
    required this.height,
    required this.width,
    required this.sourceFuture,
  });

  final double height, width;
  final Future<List<Post>> sourceFuture;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: height * .1),
      child: FutureBuilder<List<Post>>(
        future: sourceFuture,
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
    PopmenuItemsFactory factory =
        PopmenuItemsFactory(startegy: NotificationMenuStrategy());

    final commandInvoker = CommandInvoker({
      "buka": BukaCommand(),
    });
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        right: 8,
        left: 8,
      ),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Icon(Icons.warning),
            ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "A001",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface),
                        ),
                        Text(
                          "01/12/2024",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inverseSurface),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pengajuan penelitian internal ditolak",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Manrope',
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          "terjadi pelanggaran kebijakan dalam pengajuan formulir. deadline perbaikan hingga tanggal 1 agustus 2024",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Manrope',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            (factory.getList.isNotEmpty
                ? PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) {
                      return factory.getList;
                    },
                    onSelected: (String value) => {
                      if (value == "buka")
                        {
                          commandInvoker.executeCommand(value, params: {
                            'context': context,
                          })
                        }
                    },
                  )
                : SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
