import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Components/VerticalTimeline/ItemsTimeline.dart';
import 'package:sipaksi/Module/Notification/NotificationPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiDosenPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiMahasiswaMbkmPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiMahasiswaPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiNonDosenPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenKontrak/DokumenKontrakPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenPendukung/DokumenPendukungPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/JudulTahunPenelitian/JudulTahunUsulanPage.dart';
import 'package:sipaksi/Components/VerticalTimeline/Timeline.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/LuaranTambahanPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/SubstansiPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/LuaranWajibPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/PrioritasRiset/PrioritasRisetPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Rab/RabPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/RumpunIlmu/RumpunIlmuPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/SkemaPenelitian/SkemaPenelitianPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Entity/Status.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'dart:math' as math;

import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InternalResearchFormPage extends StatefulWidget {
  const InternalResearchFormPage({super.key});

  @override
  State<InternalResearchFormPage> createState() =>
      _InternalResearchFormPageState();
}

class _InternalResearchFormPageState extends State<InternalResearchFormPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    List<ItemsTimeline> list = [
      ItemsTimeline(
        title: NameTimeline.step1.title,
        subItems: [
          ItemsTimeline(
            title: NameTimeline.step1_1.title,
            isDone: false,
            required: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JudulTahunUsulanPage(),
                ),
              );
            },
            subItems: [],
          ),
          ItemsTimeline(
            title: NameTimeline.step1_2.title,
            description: NameTimeline.step1_2.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SkemaPenelitianPage(),
                ),
              );
            },
            subItems: [],
          ),
        ],
      ),
      ItemsTimeline(
        title: NameTimeline.step2.title,
        subItems: [
          ItemsTimeline(
            title: NameTimeline.step2_1.title,
            description: NameTimeline.step2_1.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrioritasRisetPage(),
                ),
              );
            },
            subItems: [],
          ),
          ItemsTimeline(
            title: NameTimeline.step2_2.title,
            description: NameTimeline.step2_2.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RumpunIlmuPage(),
                ),
              );
            },
            subItems: [],
          ),
        ],
      ),
      ItemsTimeline(
        title: NameTimeline.step3.title,
        subItems: [
          ItemsTimeline(
            title: NameTimeline.step3_1.title,
            description: NameTimeline.step3_1.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnggotaPenelitiDosenPage(),
                ),
              );
            },
            subItems: [],
          ),
          ItemsTimeline(
            title: NameTimeline.step3_2.title,
            required: true,
            isDone: true,
            action: () {},
            subItems: [
              ItemsTimeline(
                title: NameTimeline.step3_2_1.title,
                required: true,
                isDone: true,
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AnggotaPenelitiMahasiswaPage(),
                    ),
                  );
                },
                subItems: [],
              ),
              ItemsTimeline(
                title: NameTimeline.step3_2_2.title,
                required: true,
                isDone: true,
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AnggotaPenelitiMahasiswaMbkmPage(),
                    ),
                  );
                },
                subItems: [],
              ),
            ],
          ),
          ItemsTimeline(
            title: NameTimeline.step3_3.title,
            description: NameTimeline.step3_3.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnggotaPenelitiNonDosenPage(),
                ),
              );
            },
            subItems: [],
          ),
        ],
      ),
      ItemsTimeline(
        title: NameTimeline.step4.title,
        subItems: [
          ItemsTimeline(
            title: NameTimeline.step4_1.title,
            description: NameTimeline.step4_1.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubstansiPage(),
                ),
              );
            },
            subItems: [],
          ),
          ItemsTimeline(
            title: NameTimeline.step4_2.title,
            description: NameTimeline.step4_2.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LuaranWajibPage(),
                ),
              );
            },
            subItems: [],
          ),
          ItemsTimeline(
            title: NameTimeline.step4_3.title,
            description: NameTimeline.step4_3.description,
            required: false,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LuaranTambahanPage(),
                ),
              );
            },
            subItems: [],
          ),
        ],
      ),
      ItemsTimeline(
        title: NameTimeline.step5.title,
        subItems: [
          ItemsTimeline(
            title: NameTimeline.step5_1.title,
            description: NameTimeline.step5_1.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RabPage(),
                ),
              );
            },
            subItems: [],
          ),
        ],
      ),
      ItemsTimeline(
        title: NameTimeline.step6.title,
        subItems: [
          ItemsTimeline(
            title: NameTimeline.step6_1.title,
            description: NameTimeline.step6_1.description,
            required: false,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DokumenPendukungPage(),
                ),
              );
            },
            subItems: [],
          ),
        ],
      ),
      ItemsTimeline(
        title: NameTimeline.step7.title,
        subItems: [
          ItemsTimeline(
            title: NameTimeline.step7_1.title,
            description: NameTimeline.step7_1.description,
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DokumenKontrakPage(),
                ),
              );
            },
            subItems: [],
          ),
        ],
      ),
    ];

    Status status = Status.parse("tolak_pendanaan");
    Module current = Module.penelitian_internal;

    return Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth >= 540
                  ? SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    );
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: Hero(
            tag: Module.penelitian_internal.value,
            child: Text(
              Module.penelitian_internal.value,
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
                    child: SingleChildScrollView(
                      child: Content(
                        width: width,
                        height: height,
                        status: status,
                        list: list,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Content(
                    width: width,
                    height: height,
                    status: status,
                    list: list,
                  ),
                ),
              );
            }
          },
        ));
  }
}

class Content extends StatefulWidget {
  const Content({
    super.key,
    required this.height,
    required this.width,
    required this.status,
    required this.list,
  });

  final double height, width;
  final Status status;
  final List<ItemsTimeline> list;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget?> getWidgets(String type, List<ItemsTimeline> items, int node) {
      List<Widget?> children = [];

      for (var item in items) {
        if (type == "indicator") {
          if (node == 0) {
            children.add(
              Text(
                item.title, //header
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
            if (item.subItems.isNotEmpty) {
              children.addAll(getWidgets(type, item.subItems, node + 1));
            }
          } else {
            children.add(
              Container(
                child: Icon(
                  Icons.circle_outlined,
                  color: !item.isDone
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.surfaceDim,
                ),
              ),
            );
          }
        } else {
          if (node == 0) {
            children.add(const SizedBox());
            if (item.subItems.isNotEmpty) {
              children.addAll(getWidgets(type, item.subItems, node + 1));
            }
          } else {
            children.add(Section(
              title: item.title,
              subtitle: item.description,
              isDone: item.isDone, //3_2_1 & 3_2_2 ada bug state isDone
              required: item.required,
              subRender: item.subItems.isNotEmpty
                  ? Timeline(
                      hideIndicator: [],
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      indicators: getWidgets("indicator", item.subItems, 1),
                      children: getWidgets("child", item.subItems, 1),
                    )
                  : null,
              onBackPressed: item.action ?? () {},
            ));
          }
        }
      }

      return children;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> x = [];
        print("width: ${constraints.maxWidth}");
        if (constraints.maxWidth >= 540) {
          x.add(
            StepBreadCrumb.createBreadCrumb(context: context, list: [
              ItemStepCreadCrumb(
                icon: Icons.home,
                onTap: () => Navigator.of(context)
                  ..pop()
                  ..pop(),
              ),
              ItemStepCreadCrumb(
                title: Module.penelitian_internal.value,
                onTap: () => Navigator.of(context).pop(),
              ),
              ItemStepCreadCrumb(
                title: "Form Pengajuan",
                onTap: null,
              ),
            ]),
          );
        }

        print('current level: ${prefs?.getString('level')}');
        x.addAll([
          prefs?.getString('level') == "dosen" ||
                  prefs?.getString('level') == null
              ? StatusWithHistoryComponent(status: widget.status)
              : SizedBox.shrink(),
          prefs?.getString('level') == "dosen" ||
                  prefs?.getString('level') == null
              ? const SizedBox(height: 5)
              : SizedBox.shrink(),
          prefs?.getString('level') == "dosen" ||
                  prefs?.getString('level') == null
              ? Divider(
                  color: Theme.of(context).colorScheme.surfaceDim,
                  thickness: 0,
                  height: 2,
                )
              : SizedBox.shrink(),
          const SizedBox(height: 15),
          prefs?.getString('level') == "dosen" ||
                  prefs?.getString('level') == null
              ? const HeaderComponent()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tiket Perbaikan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    CurrentTicket(),
                  ],
                ),
          const SizedBox(height: 10),
          Timeline(
            hideIndicator: [8],
            indicators: getWidgets("indicator", widget.list, 0),
            children: getWidgets("child", widget.list, 0),
          )
        ]);

        return Container(
          margin: EdgeInsets.only(
            left: widget.width * .01,
            right: widget.width * .01,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: x.toList(),
          ),
        );
      },
    );
  }
}

class CurrentTicket extends StatefulWidget {
  const CurrentTicket({super.key});

  @override
  State<CurrentTicket> createState() => _CurrentTicketState();
}

class _CurrentTicketState extends State<CurrentTicket> {
  String? currentTicket;
  String? lastTicket;
  bool loadingCurrentTicket = false;
  bool _isDisposed = false;

  Future<void> createTicket() async {
    print("Buat tiket");
    if (_isDisposed) return;

    if (currentTicket == null && lastTicket == null) {
      setState(() {
        loadingCurrentTicket = true;
      });
      await Future.delayed(const Duration(seconds: 2), () {
        if (!_isDisposed) {
          setState(() {
            currentTicket = "A001";
            lastTicket = "A001";
            loadingCurrentTicket = false;
          });
        }
      });

      await Future.delayed(const Duration(seconds: 1), () {
        if (!_isDisposed) {
          setState(() {
            currentTicket = null;
          });
        }
      });
    }
  }

  Future<void> updateTicket() async {
    if (_isDisposed) return;

    if (currentTicket != lastTicket) {
      print("Perbaharui tiket");

      setState(() {
        loadingCurrentTicket = true;
      });
      await Future.delayed(const Duration(seconds: 2), () {
        if (!_isDisposed) {
          setState(() {
            currentTicket = "A002";
            lastTicket = "A002";
            loadingCurrentTicket = false;
          });
        }
      });
    }
  }

  Future<void> loadCurrentTicket() async {
    if (_isDisposed) return;

    setState(() {
      loadingCurrentTicket = true;
    });
    await Future.delayed(const Duration(seconds: 3), () {
      if (!_isDisposed) {
        setState(() {
          loadingCurrentTicket = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (currentTicket == null) {
      loadCurrentTicket();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget render = Container();
    if (currentTicket == null && lastTicket == null) {
      render = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Skeletonizer(
            enabled: loadingCurrentTicket,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Tidak ada tiket perbaikan',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Manrope',
                    ),
                  ),
                  const WidgetSpan(
                    child: SizedBox(width: 5),
                  ),
                  TextSpan(
                    text: "Buat Tiket Perbaikan",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await createTicket();
                      },
                  ),
                ],
              ),
            ),
          )
        ],
      );
    } else if (lastTicket != null) {
      render = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: currentTicket ?? "-",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Manrope',
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 5),
                ),
                TextSpan(
                  text: "Perbaharui Tiket",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await updateTicket();
                    },
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NotificationPage(), //harusnya ke detail
                ),
              );
            },
            icon: Icon(Icons.arrow_right),
          ),
        ],
      );
    }
    return render;
  }
}

class StatusWithHistoryComponent extends StatelessWidget {
  const StatusWithHistoryComponent({
    super.key,
    required this.status,
  });

  final Status status;

  dynamic getValue(BuildContext context, String type, Status status) {
    if ([
      Status.tolak,
      Status.tolak_pendanaan,
      Status.tolak_anggota,
      Status.terima,
      Status.terima_pendanaan,
    ].contains(status)) {
      return type == "icon"
          ? Icons.close_rounded
          : Theme.of(context).colorScheme.error;
    } else if ([
      Status.menunggu_anggota,
      Status.menunggu_review_fakultas,
      Status.menunggu_review_lppm,
      Status.menunggu_pilih_reviewer,
      Status.menunggu_reviewer,
      Status.draf,
    ].contains(status)) {
      return type == "icon"
          ? Icons.timelapse
          : Theme.of(context).colorScheme.tertiary;
    }

    return type == "icon"
        ? Icons.timelapse
        : Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update Status",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Row(
                children: [
                  Icon(
                    getValue(context, "icon", status),
                    color: getValue(context, "color", status),
                    size: 18,
                  ),
                  Flexible(
                    child: Text(
                      status.value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: status.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  children: [
                    const TextSpan(
                      text: "01/12/2024 - ditolak reviewer",
                    ),
                    TextSpan(
                      text: " Detail",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Detail clicked");
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderComponent extends StatelessWidget {
  const HeaderComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
            maxWidth: 80,
          ),
          padding: const EdgeInsets.only(right: 15),
          child: Image.asset('lib/assets/images/fast.png'),
        ),
        Expanded(
          child: Text(
            "Bagikan data penelitian anda sekarang untuk pemeriksanaan kualitas penelitian sebelum diterima LPPM. Ada 7 bagian harus dilengkapi secara lengkap, ada beberapa point yg opsional namun jika anda lengkapi menjadi nilai tambah dalam penilaian dalam menentukan penerimaan pendanaan.",
            style: TextStyle(
              height: 1.2,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isDone;
  final bool required;
  final Widget? subRender;
  final VoidCallback onBackPressed;

  const Section({
    Key? key,
    required this.title,
    this.subtitle,
    this.isDone = false,
    this.required = false,
    this.subRender,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Hero(
                  tag: title,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: TextStyle(
                            fontSize: 14,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                            fontWeight: FontWeight.w300,
                            color: isDone
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        TextSpan(
                          text: required ? " *" : "",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (subtitle == null && subRender == null)
                Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: IconButton(
                    iconSize: 14,
                    onPressed: onBackPressed,
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: isDone
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    subtitle ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: isDone
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: IconButton(
                    iconSize: 14,
                    onPressed: onBackPressed,
                    icon: const Icon(Icons.arrow_back_ios_outlined),
                  ),
                ),
              ],
            ),
          if (subRender != null) Flexible(child: subRender!),
        ],
      ),
    );
  }
}
