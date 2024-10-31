import 'package:flutter/material.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/Filter/LuaranFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/ItemList/LuaranStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Rab/Fetch/RabFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Rab/Form/RabFormPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Post.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';

class RabPage extends StatefulWidget {
  const RabPage({super.key});

  @override
  State<RabPage> createState() => _RabPageState();
}

class _RabPageState extends State<RabPage> {
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  List<int?> getListSelected() {
    return anggotaPenelitianManager.selectedItems
        .map<int?>((dosen) => dosen?.id)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    anggotaPenelitianManager = AnggotaPenelitianManager<Post>(
      RabFetchStrategy(),
      LuaranFilterStrategy(),
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
        title: Hero(
          tag: "Data RAB",
          child: Text(
            "Data RAB",
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
                    Wrap(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RabFormPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Tambah Data',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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
                      itemListStrategy: LuaranStrategy(),
                    )
                  ],
                ),
              ),
            ),
          ),
          FooterAction(
            isLoading: isLoading,
            optionalBuilder: (height) =>
                getListSelected().isNotEmpty || isLoading.value
                    ? TextButton(
                        onPressed: () {
                          !isLoading.value
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Data berhasil hapus!'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: height + 8,
                                    ),
                                  ),
                                )
                              : null;
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    : Container(),
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
            },
          ),
        ],
      ),
    );
  }
}
