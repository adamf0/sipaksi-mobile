import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownItems.dart';
import 'package:sipaksi/Components/DropdownSearch/DropdownSearch.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';

class RabFormPage extends StatefulWidget {
  const RabFormPage({super.key});

  @override
  State<RabFormPage> createState() => _RabFormPageState();
}

class _RabFormPageState extends State<RabFormPage> {
  final ValueNotifier<List<DropdownItems>> badgesKelompok = ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredKelompok = ValueNotifier([]);

  final ValueNotifier<List<DropdownItems>> badgesKomponen = ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredKomponen = ValueNotifier([]);

  final ValueNotifier<List<DropdownItems>> badgesSatuan = ValueNotifier([]);
  final ValueNotifier<List<DropdownItems>> filteredSatuan = ValueNotifier([]);

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _hargaSatuanController = TextEditingController();
  final TextEditingController _subTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _itemController.text = "";
    _hargaSatuanController.text = "";
    _subTotalController.text = "";

    _itemController.addListener(_updateSubtotal);
    _hargaSatuanController.addListener(_updateSubtotal);
  }

  @override
  void dispose() {
    _itemController.dispose();
    _hargaSatuanController.dispose();
    _subTotalController.dispose();
    super.dispose();
  }

  void _updateSubtotal() {
    final int item = int.tryParse(_itemController.text) ?? 0;
    final int hargaSatuan = int.tryParse(_hargaSatuanController.text) ?? 0;
    final int subTotal = item * hargaSatuan;

    _subTotalController.text = subTotal.toString();
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
          "Tambah Rab",
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
                      "Kelompok",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    DropdownSearch(
                      badgesNotifier: badgesKelompok,
                      filteredNotifier: filteredKelompok,
                      fetchUsers: (query) async {
                        await _fetchData(query, filteredKelompok);
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Komponen",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    DropdownSearch(
                      badgesNotifier: badgesKomponen,
                      filteredNotifier: filteredKomponen,
                      fetchUsers: (query) async {
                        await _fetchData(query, filteredKomponen);
                      },
                      eventChange: () {},
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Item",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextField(
                      controller: _itemController,
                      keyboardType: TextInputType.number,
                      obscureText: false, // Negate the value
                      onChanged: (value) => {},
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
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
                      "Satuan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    DropdownSearch(
                      badgesNotifier: badgesSatuan,
                      filteredNotifier: filteredSatuan,
                      fetchUsers: (query) async {
                        await _fetchData(query, filteredSatuan);
                      },
                      eventChange: () {},
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Harga Satuan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextField(
                      controller: _hargaSatuanController,
                      keyboardType: TextInputType.number,
                      obscureText: false, // Negate the value
                      onChanged: (value) => {},
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
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
                      "Sub Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextField(
                      controller: _subTotalController,
                      keyboardType: TextInputType.number,
                      obscureText: false, // Negate the value
                      onChanged: (value) => {},
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
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
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
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
                      .closed
                      .then((_) => Navigator.of(context).pop());
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
