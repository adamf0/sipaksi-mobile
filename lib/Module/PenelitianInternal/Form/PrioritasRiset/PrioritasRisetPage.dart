import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownItems.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownSearch.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/PrioritasRiset/Provider/LoadingSavePrioritasRisetState.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/DefaultState.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Shared/LoadingManager.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

class PrioritasRisetPage extends StatefulWidget {
  const PrioritasRisetPage({super.key});

  @override
  State<PrioritasRisetPage> createState() => _PrioritasRisetPageState();
}

class _PrioritasRisetPageState extends State<PrioritasRisetPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSavePrioritasRisetState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSavePrioritasRisetState>(context);

              return constraints.maxWidth >= 640
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
            tag: NameTimeline.step2_1.title,
            child: Text(
              NameTimeline.step2_1.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 640) {
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
  final ValueNotifier<List<DropdownItems>> badgesPrioritasRiset =
      ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredPrioritasRiset =
      ValueNotifier([]);

  final ValueNotifier<List<DropdownItems>> badgesBidangFokus =
      ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredBidangFokus =
      ValueNotifier([]);

  final ValueNotifier<List<DropdownItems>> badgesTema = ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredTema = ValueNotifier([]);

  final ValueNotifier<List<DropdownItems>> badgesTopik = ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredTopik = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingSavePrioritasRisetState>(context);
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
                      return constraints.maxWidth >= 640
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
                                      title: NameTimeline.step2_1.title,
                                      onTap: null,
                                    ),
                                  ]),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  Text(
                    "Prioritas Riset",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  DropdownSearch(
                    badgesNotifier: badgesPrioritasRiset,
                    filteredNotifier: filteredPrioritasRiset,
                    fetchUsers: (query) async {
                      await _fetchData(query, filteredPrioritasRiset);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Bidang Fokus Penelitian",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  DropdownSearch(
                    badgesNotifier: badgesBidangFokus,
                    filteredNotifier: filteredBidangFokus,
                    fetchUsers: (query) async {
                      await _fetchData(query, filteredBidangFokus);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tema",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  DropdownSearch(
                    badgesNotifier: badgesTema,
                    filteredNotifier: filteredTema,
                    fetchUsers: (query) async {
                      await _fetchData(query, filteredTema);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Topik",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  DropdownSearch(
                    badgesNotifier: badgesTopik,
                    filteredNotifier: filteredTopik,
                    fetchUsers: (query) async {
                      await _fetchData(query, filteredTopik);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        FooterAction(
          isLoading: loadingManager.stateLoading,
          optionalBuilder: (height) => SizedBox.shrink(),
          onPress: (double height) {
            if (!loadingState.isLoadingSave) {
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

Future<void> _fetchData(
    String query, ValueNotifier<List<DropdownItems>> notifier) async {
  try {
    var response = await Dio().get(
      "https://63c1210999c0a15d28e1ec1d.mockapi.io/users",
      queryParameters: {'search': query},
    );

    final data = response.data;

    if (data != null) {
      notifier.value = DropdownItems.fromJsonList(data);
    }
  } catch (error) {
    notifier.value = [];
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout) {
        print("Connection Timeout: Please check your internet connection.");
      } else if (error.type == DioExceptionType.sendTimeout) {
        print("Send Timeout: The request took too long to send.");
      } else if (error.type == DioExceptionType.receiveTimeout) {
        print("Receive Timeout: The server is taking too long to respond.");
      } else if (error.type == DioExceptionType.unknown) {
        print("Network Error: Please check your internet connection.");
      } else if (error.response != null) {
        final statusCode = error.response!.statusCode;
        final errorMessage = error.response!.data.toString();
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          print("Client Error ($statusCode): $errorMessage");
        } else if (statusCode != null && statusCode >= 500) {
          print("Server Error ($statusCode): $errorMessage");
        }
      }
    } else if (error is FormatException) {
      print("Data Format Error: ${error.message}");
    } else if (error is TypeError) {
      print("Type Error: Please check variable types.");
    } else {
      print("Unexpected error occurred: $error");
    }
  }
}
