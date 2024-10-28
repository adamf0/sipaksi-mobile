import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownItems.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownSearch.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';

class PrioritasRisetPage extends StatefulWidget {
  const PrioritasRisetPage({super.key});

  @override
  State<PrioritasRisetPage> createState() => _PrioritasRisetPageState();
}

class _PrioritasRisetPageState extends State<PrioritasRisetPage> {
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
            optionalBuilder: (height) => Container(),
            onPress: (double height) => {
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
              )
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
