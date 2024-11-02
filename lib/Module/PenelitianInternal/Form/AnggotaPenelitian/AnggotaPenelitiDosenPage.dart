import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Fetch/DosenFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Filter/DosenFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/ItemList/DosenItemListStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';

class AnggotaPenelitiDosenPage extends StatefulWidget {
  const AnggotaPenelitiDosenPage({super.key});

  @override
  State<AnggotaPenelitiDosenPage> createState() =>
      _AnggotaPenelitiDosenPageState();
}

class _AnggotaPenelitiDosenPageState extends State<AnggotaPenelitiDosenPage> {
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    anggotaPenelitianManager = AnggotaPenelitianManager<Post>(
      DosenFetchStrategy(),
      DosenFilterStrategy(),
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
          tag: "Anggota Peneliti (Dosen)",
          child: Text(
            "Anggota Peneliti (Dosen)",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      itemListStrategy: DosenItemListStrategy(),
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
