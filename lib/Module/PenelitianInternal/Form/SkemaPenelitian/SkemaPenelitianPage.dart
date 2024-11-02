import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Components/CenterLoading/CenterLoadingComponent.dart';
import 'package:sipaksi/Components/Error/DataNotFoundComponent.dart';
import 'package:sipaksi/Components/Error/ErrorComponent.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/SkemaPenelitian/Provider/LoadingSaveSkemaPenelitianState.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/SkemaPenelitian/RadioModel.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SkemaPenelitianPage extends StatefulWidget {
  const SkemaPenelitianPage({super.key});

  @override
  State<SkemaPenelitianPage> createState() => _SkemaPenelitianPageState();
}

class _SkemaPenelitianPageState extends State<SkemaPenelitianPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveSkemaPenelitianState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSaveSkemaPenelitianState>(context);

              return constraints.maxWidth >= 768
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => !loadingState.isLoadingSave.value
                          ? Navigator.of(context).pop()
                          : null,
                    );
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: Hero(
            tag: NameTimeline.step1_2.title,
            child: Text(
              NameTimeline.step1_2.title,
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
  List<RadioModel> listKategori = [];
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
    } on DioException catch (e) {
      print("SkemaPenelitianPage [getPosts](DioError): ${e.message}");
      rethrow;
    } catch (e) {
      print("SkemaPenelitianPage [getPosts](Error): $e");
      rethrow;
    }
  }

  late List<String> errorMessages = [];
  late Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = getPosts();
    listKategori.add(RadioModel(
      isSelected: false,
      key: '1',
      value: 'Penelitian Dosen Pemula (PDP)',
    ));
    listKategori.add(RadioModel(
      isSelected: false,
      key: '2',
      value: 'Penelitian Dasar',
    ));
    listKategori.add(RadioModel(
      isSelected: false,
      key: '3',
      value: 'Penelitian Terapan',
    ));
    listKategori.add(RadioModel(
      isSelected: false,
      key: '4',
      value: 'Penelitian Kolaborasi',
    ));
  }

  RadioModel? kategoriSkema;
  double tkt = 0;
  double start_tick = 0;
  Post? kategoriTkt;

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingSaveSkemaPenelitianState>(context);

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
                                      title: NameTimeline.step1_2.title,
                                      onTap: () => {},
                                    ),
                                  ]),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Kategori Skema",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          kategoriSkema == null ? "tidak boleh kosong" : "",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemCount: listKategori.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          // splashColor: Colors.blueAccent,
                          onTap: () {
                            setState(() {
                              for (var element in listKategori) {
                                element.isSelected = false;
                              }
                              listKategori[index].isSelected = true;
                              kategoriSkema = listKategori[index];
                            });
                          },
                          child: RadioItem(listKategori[index]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "TKT",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tkt == start_tick ? "tidak boleh kosong" : "",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SfSlider(
                    min: start_tick,
                    max: 9,
                    interval: 1,
                    stepSize: 1,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    value: tkt,
                    activeColor: Theme.of(context).colorScheme.tertiary,
                    inactiveColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    onChanged: (dynamic newValue) {
                      setState(() {
                        tkt = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Kategori TKT",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          kategoriTkt == null ? "tidak boleh kosong" : "",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List<Post>>(
                    future: postsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CenterLoadingComponent(height: 50);
                      } else if (snapshot.hasError) {
                        // errorMessages.add(snapshot.error.toString());
                        return ErrorComponent(
                          height: widget.height,
                          errorMessage: snapshot.error.toString(),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return DataNotFoundComponent(width: widget.width);
                      } else {
                        final posts = snapshot.data!;
                        return ListView.builder(
                          itemCount: posts.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return ListTile(
                              title: Text(post.title ?? "-",
                                  style: TextStyle(
                                    color: post.title == kategoriTkt?.title
                                        ? Theme.of(context).colorScheme.tertiary
                                        : Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                  )),
                              leading: Radio<Post>(
                                value: post,
                                activeColor:
                                    Theme.of(context).colorScheme.tertiary,
                                groupValue: kategoriTkt,
                                onChanged: (Post? value) {
                                  setState(() {
                                    kategoriTkt = value;
                                  });
                                  print(kategoriTkt?.title);
                                },
                              ),
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
          isLoading: loadingState.isLoadingSave,
          optionalBuilder: (height) => SizedBox.shrink(),
          onPress: (double height) {
            if (!loadingState.isLoadingSave.value) {
              loadingState.isLoadingSave.value = true;
              Future.delayed(const Duration(seconds: 2), () {
                loadingState.isLoadingSave.value = false;
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

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  const RadioItem(this._item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: const EdgeInsets.only(right: 15, top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _item.isSelected
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Colors.transparent,
        border: Border.all(
          width: 1.0,
          color: _item.isSelected
              ? Theme.of(context).colorScheme.tertiaryContainer
              : Theme.of(context).colorScheme.primaryContainer,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: Text(
          _item.value,
          style: TextStyle(
            color: _item.isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
