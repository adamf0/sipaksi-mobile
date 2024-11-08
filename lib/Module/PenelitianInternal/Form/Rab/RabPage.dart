import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/Filter/LuaranFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/ItemList/LuaranStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Rab/Fetch/RabFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Rab/Form/RabFormPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Rab/Provider/LoadingSaveRabState.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/DefaultState.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';
import 'package:sipaksi/Module/Shared/LoadingManager.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

class RabPage extends StatefulWidget {
  const RabPage({super.key});

  @override
  State<RabPage> createState() => _RabPageState();
}

class _RabPageState extends State<RabPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveRabState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState = Provider.of<LoadingSaveRabState>(context);

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
          title: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth >= 540
                ? SizedBox.shrink()
                : Text(
                    NameTimeline.step5_1.title,
                    style: TextStyle(color: Colors.white),
                  ),
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
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;

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
    final loadingState = Provider.of<LoadingSaveRabState>(context);
    LoadingManager loadingManager =
        LoadingManager(DefaultState(loadingState.isLoadingSave));

    return Column(
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
                          foregroundColor: Theme.of(context).colorScheme.error,
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
                      print(listToJson(anggotaPenelitianManager.selectedItems));
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
          isLoading: loadingManager.stateLoading,
          optionalBuilder: (height) {
            if (loadingState.isLoadingSave) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              );
            } else if (!loadingState.isLoadingSave &&
                getListSelected().isNotEmpty) {
              return TextButton(
                onPressed: () {
                  if (!loadingState.isLoadingSave) {
                    setState(() {
                      loadingState.setLoading(true);
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Data berhasil dihapus!'),
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
                      setState(() {
                        loadingState.setLoading(false);
                      });
                    });
                  }
                  // print("footerHeight: ${height.toString()}");
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text(
                  'Hapus',
                  style: TextStyle(fontSize: 14),
                ),
              );
            }

            return SizedBox.shrink();
          },
          buttonHide: true,
          onPress: (double height) {},
        ),
      ],
    );
  }
}
