import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownItems.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownSearch.dart';
import 'package:sipaksi/Module/ColorExtension.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/NumericalRangeFormatter.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';

class RumpunIlmuPage extends StatefulWidget {
  const RumpunIlmuPage({super.key});

  @override
  State<RumpunIlmuPage> createState() => _RumpunIlmuPageState();
}

class _RumpunIlmuPageState extends State<RumpunIlmuPage> {
  final ValueNotifier<List<DropdownItems>> badgesRumpunIlmu1 =
      ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredRumpunIlmu1 =
      ValueNotifier([]);

  final ValueNotifier<List<DropdownItems>> badgesRumpunIlmu2 =
      ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredRumpunIlmu2 =
      ValueNotifier([]);

  final ValueNotifier<List<DropdownItems>> badgesRumpunIlmu3 =
      ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredRumpunIlmu3 =
      ValueNotifier([]);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
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
          onPressed: () =>
              !isLoading.value ? Navigator.of(context).pop() : null,
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
                    Text(
                      "Rumpun Ilmu 1",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    DropdownSearch(
                      badgesNotifier: badgesRumpunIlmu1,
                      filteredNotifier: filteredRumpunIlmu1,
                      fetchUsers: (query) async {
                        await _fetchData(query, filteredRumpunIlmu1);
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Rumpun Ilmu 2",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    DropdownSearch(
                      badgesNotifier: badgesRumpunIlmu2,
                      filteredNotifier: filteredRumpunIlmu2,
                      fetchUsers: (query) async {
                        await _fetchData(query, filteredRumpunIlmu2);
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Rumpun Ilmu 3",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    DropdownSearch(
                      badgesNotifier: badgesRumpunIlmu3,
                      filteredNotifier: filteredRumpunIlmu3,
                      fetchUsers: (query) async {
                        await _fetchData(query, filteredRumpunIlmu3);
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Lama Kegiatan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextField(
                      // controller: widget.controller,
                      keyboardType: TextInputType.number,
                      obscureText: false, // Negate the value
                      onChanged: (value) => {},
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        NumericalRangeFormatter()
                      ],
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Bulan"), //ini masih masalah
                            ],
                          ),
                        ),
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
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        //   borderSide:
                        //       const BorderSide(color: Colors.red, width: 1),
                        // ),
                        // focusedErrorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        //   borderSide:
                        //       const BorderSide(color: Colors.red, width: 2),
                        // ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          FooterAction(
            isLoading: isLoading,
            optionalBuilder: (height) => Container(),
            onPress: (double height) {
              if (!isLoading.value) {
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
