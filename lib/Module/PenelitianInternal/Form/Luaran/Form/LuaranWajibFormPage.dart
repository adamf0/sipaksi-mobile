import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownItems.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownSearch.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/Form/Provider/LoadingSaveLuaranWajibFormState.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/DefaultState.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Shared/LoadingManager.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

class LuaranWajibFormPage extends StatefulWidget {
  const LuaranWajibFormPage({super.key});

  @override
  State<LuaranWajibFormPage> createState() => _LuaranWajibFormPageState();
}

class _LuaranWajibFormPageState extends State<LuaranWajibFormPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveLuaranWajibFormState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSaveLuaranWajibFormState>(context);

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
            NameTimeline.step4_2.title,
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
  final ValueNotifier<List<DropdownItems>> badgesKategori = ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredKategori = ValueNotifier([]);

  final ValueNotifier<List<DropdownItems>> badgesLuaran = ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredLuaran = ValueNotifier([]);

  final TextEditingController _statusController = TextEditingController();
  String status = "";

  @override
  void initState() {
    super.initState();
    _statusController.text = status;
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingSaveLuaranWajibFormState>(context);
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
                  Text(
                    "Kategori",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  DropdownSearch(
                    badgesNotifier: badgesKategori,
                    filteredNotifier: filteredKategori,
                    fetchUsers: (query) async {
                      await _fetchData(query, filteredKategori);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Luaran",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  DropdownSearch(
                    badgesNotifier: badgesLuaran,
                    filteredNotifier: filteredLuaran,
                    fetchUsers: (query) async {
                      await _fetchData(query, filteredLuaran);
                    },
                    eventChange: () {
                      if (badgesLuaran.value.isNotEmpty) {
                        _statusController.text =
                            badgesLuaran.value.first.extra.toString();
                      } else {
                        _statusController.text = "";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextField(
                    controller: _statusController,
                    // enabled: false,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (value) => {},
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Keterangan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextField(
                    // controller: widget.controller,
                    keyboardType: TextInputType.text,
                    obscureText: false, // Negate the value
                    onChanged: (value) => {},
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                    decoration: InputDecoration(
                      errorText: "belum diisi",
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Link",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextField(
                    // controller: widget.controller,
                    keyboardType: TextInputType.url,
                    obscureText: false, // Negate the value
                    onChanged: (value) => {},
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                    decoration: InputDecoration(
                      errorText: "belum diisi",
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
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
            if (!loadingManager.stateLoading) {
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
                // .closed
                // .then((_) => Navigator.of(context).pop());
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
