import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Components/DropdownSearch/Debouncer.dart';
import 'package:sipaksi/Components/Listview/CustomListView.dart';
import 'package:sipaksi/Components/Search/Search.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitianManager.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Fetch/DosenFetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Filter/DosenFilterStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/ItemList/DosenItemListStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/Provider/LoadingSaveAggotaPenelitiState.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Post.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/DefaultState.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Shared/LoadingManager.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

class AnggotaPenelitiDosenPage extends StatefulWidget {
  const AnggotaPenelitiDosenPage({super.key});

  @override
  State<AnggotaPenelitiDosenPage> createState() =>
      _AnggotaPenelitiDosenPageState();
}

class _AnggotaPenelitiDosenPageState extends State<AnggotaPenelitiDosenPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveAggotaPenelitiState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSaveAggotaPenelitiState>(context);

              return constraints.maxWidth >= 768
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
            tag: NameTimeline.step3_1.title,
            child: Text(
              NameTimeline.step3_1.title,
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
  late AnggotaPenelitianManager<Post> anggotaPenelitianManager;

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
    final loadingState = Provider.of<LoadingSaveAggotaPenelitiState>(context);
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
                                      title: NameTimeline.step3_1.title,
                                      onTap: null,
                                    ),
                                  ]),
                            )
                          : SizedBox.shrink();
                    },
                  ),
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
                      print(listToJson(anggotaPenelitianManager.selectedItems));
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
