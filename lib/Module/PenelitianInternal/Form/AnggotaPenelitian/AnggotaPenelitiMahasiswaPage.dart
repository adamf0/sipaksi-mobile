import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Fetch/MahasiswaFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Filter/MahasiswaFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/ItemList/MahasiswaItemListStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
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
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    anggotaPenelitianManager = AnggotaPenelitianManager<Post>(
      MahasiswaFetchStrategy(),
      MahasiswaFilterStrategy(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Debouncer _debouncer = Debouncer(milliseconds: 500);

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
        title: const Hero(
          tag: "Data Mahasiswa",
          child: Text(
            "Data Mahasiswa",
            style: TextStyle(color: Colors.white),
          ),
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
                    Search(
                      onChange: (term) => _debouncer.run(() {
                        anggotaPenelitianManager.updateSearchTerm(term);
                      }),
                    ),
                    const SizedBox(height: 10),
                    CustomListView<Post>(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      source: anggotaPenelitianManager.dataFuture,
                      filteredData: anggotaPenelitianManager.filteredData,
                      onSelectedChanged: (post) {
                        setState(() {
                          if (anggotaPenelitianManager.selectedItems
                              .contains(post)) {
                            anggotaPenelitianManager.selectedItems.remove(post);
                          } else {
                            anggotaPenelitianManager.selectedItems.add(post);
                          }
                        });
                        print(
                            listToJson(anggotaPenelitianManager.selectedItems));
                      },
                      selectedItems: anggotaPenelitianManager.selectedItems,
                      itemListStrategy: MahasiswaItemListStrategy(),
                    )
                  ],
                ),
              ),
            ),
          ),
          FooterAction(
            isLoading: isLoading,
            optionalBuilder: (height) => SizedBox.shrink(),
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
