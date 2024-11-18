import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/DropdownSearch/CloseBottomSheet.dart';
import 'package:sipaksi/Components/Notification/SmallCircleNotification.dart';
import 'package:sipaksi/Components/Popmenu/Event/LogoutCommand.dart';
import 'package:sipaksi/Module/Dashboard/Provider/LevelState.dart';
import 'package:sipaksi/Module/Dashboard/TypeSubmission.dart';
import 'package:sipaksi/Module/Notification/List/NotificationPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/InternalResearchCatalogPage.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sipaksi/Module/Helpers/Utility.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late CarouselSliderController innerCarouselController;
  int innerCurrentPage = 0;
  String level = "dosen";

  @override
  void initState() {
    super.initState();
    innerCarouselController = CarouselSliderController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TypeSubmission> listMenus = [
      TypeSubmission(
        judul: "Insentif",
        img_asset: 'lib/assets/images/money.png',
      ),
      TypeSubmission(
        judul: Module.penelitian_internal.value,
        img_asset: 'lib/assets/images/microscope.png',
      ),
      TypeSubmission(
        judul: Module.penelitian_nasional.value,
        img_asset: 'lib/assets/images/national.png',
      ),
      TypeSubmission(
        judul: Module.pkm_internal.value,
        img_asset: 'lib/assets/images/creativity.png',
      ),
      TypeSubmission(
        judul: Module.pkm_nasional.value,
        img_asset: 'lib/assets/images/compotitive.png',
      ),
      TypeSubmission(
        judul: Module.ppm.value,
        img_asset: 'lib/assets/images/international.png',
      ),
    ];

    final size = MediaQuery.of(context).size;
    final double _height = size.height;
    final double _width = size.width;
    List<String> listMode = ["dosen", "fakultas", "lppm", "reviewer"];

    return ChangeNotifierProvider(
      create: (context) => LevelState(level),
      child: ScreenUtilInit(
        designSize: Size(_width, _height),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return Scaffold(
            floatingActionButton: ButtonQuestion(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNav(
              notificationTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
              logoutTap: () {
                LogoutCommand command = new LogoutCommand();
                command.execute({"context": context});
              },
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(
                        20, clampValue(10, 10 + (_height * .018), 20), 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header(
                          hideChangeMode: listMode.length == 1,
                          changeMode: () => changeMode(context, listMode),
                          notificationTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationPage(),
                              ),
                            );
                          },
                          logoutTap: () {
                            LogoutCommand command = new LogoutCommand();
                            command.execute({"context": context});
                          },
                        ),
                        const SizedBox(height: 24),
                        const Greeting(),
                        const SizedBox(height: 18),
                        const Text(
                          "Mulai Melengkapi",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Manrope',
                          ),
                        ),
                        _buildCards(_height),
                        SizedBox(height: 10),
                        Menus(
                          height: _getMenuHeight(_height, _width),
                          width: _width,
                          listMenus: listMenus,
                          controller: innerCarouselController,
                          onTap: (tap) {
                            if (tap.judul == Module.penelitian_internal.value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const InternalResearchCatalogPage(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCards(double height) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          // For mobile: Use a single column layout
          return Column(
            children: [
              IdSintaCard(IdSinta: "123"),
              const SizedBox(height: 10),
              JabatanFungsionalCard(),
            ],
          );
        } else {
          // For desktop: Use a row layout
          return Row(
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: IdSintaCard(IdSinta: "123"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: IntrinsicHeight(
                  child: JabatanFungsionalCard(),
                ),
              ),
            ],
          );
          // return IntrinsicHeight(
          //   child: ,
          // );
        }
      },
    );
  }

  double _getMenuHeight(double height, double maxWidth) {
    return maxWidth >= 540
        ? clampValue(100, height * .28, 200)
        : clampValue(60, height * .15, 150);
  }

  changeMode(BuildContext context, List<String> listMode) async {
    final levelState = Provider.of<LevelState>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (contextSheet) {
        return StatefulBuilder(builder: (context, setState) {
          return FractionallySizedBox(
            heightFactor: 1.0,
            widthFactor: 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CloseBottomSheet(ctx: contextSheet),
                  const SizedBox(height: 10),
                  Text(
                    "Pilih Mode",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      children: [
                        for (int i = 0; i < listMode.length; i++)
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: listMode[i] == levelState.level
                                  ? Colors.grey[300]
                                  : Colors.blue[100 * (i % 9 + 1)],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: listMode[i] == levelState.level
                                ? null
                                : () async {
                                    setState(() {
                                      level = listMode[i];
                                      levelState.setLevel(listMode[i]);
                                    });
                                    Navigator.of(contextSheet).pop();
                                  },
                            child: Center(
                              child: Text(
                                listMode[i],
                                style: TextStyle(
                                  color: listMode[i] == levelState.level
                                      ? Colors.grey[700]
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    this.notificationTap,
    this.logoutTap,
  });

  final Function()? notificationTap;
  final Function()? logoutTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 540) {
          return SizedBox.shrink();
        }

        return BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 60,
          color: Theme.of(context).primaryColor,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButton(Icons.notifications, notificationTap),
              _buildIconButton(Icons.logout, logoutTap),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, Function()? onTap) {
    return icon == Icons.notifications
        ? Stack(
            children: [
              IconButton(
                icon: Icon(
                  icon,
                  color: Colors.white,
                ),
                onPressed: onTap,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: RippleAnimation(
                  size: Size(10, 10),
                  key: UniqueKey(),
                  repeat: true,
                  color: Colors.red,
                  minRadius: 10,
                  ripplesCount: 1,
                  duration: Duration(milliseconds: 2300),
                  child: SmallCircleNotification(),
                ),
              )
            ],
          )
        : IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            onPressed: onTap,
          );
  }
}

class ButtonQuestion extends StatelessWidget {
  const ButtonQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          return FloatingActionButton(
            onPressed: () {},
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.question_answer,
              color: Colors.white,
            ),
          );
        }
        return SizedBox.shrink(); // Return an empty widget for wider screens
      },
    );
  }
}

class JabatanFungsionalCard extends StatelessWidget {
  const JabatanFungsionalCard({
    super.key,
  });

  Future<void> openWhatsApp(String phoneNumber, String message) async {
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
    final Uri whatsappAppUrl = Uri.parse("whatsapp://send?phone=$phoneNumber");

    if (await canLaunchUrl(whatsappAppUrl)) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'WhatsApp is not installed on the device';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Jabatan Fungsional",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope',
                    ),
                  ),
                  Text(
                    "belum terdaftar",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Manrope',
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await openWhatsApp('+6287780065446',
                            "jafung saya dengan nidn 04xxxx belum terdaftar");
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Hubungi BAUM',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Image.asset(
                'lib/assets/images/image1.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IdSintaCard extends StatelessWidget {
  const IdSintaCard({
    super.key,
    this.IdSinta,
  });

  final String? IdSinta;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 150, // Pastikan tinggi konsisten
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sinta Saya",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope',
                    ),
                  ),
                  ...(IdSinta == null
                      ? [
                          Text(
                            "Id sinta belum terdaftar",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Manrope',
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              foregroundColor: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: const Text(
                              'Lengkapi',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ]
                      : [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                    'lib/assets/images/lengkapi.png'),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                IdSinta ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Manrope',
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    Image.asset('lib/assets/images/fast.png'),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                "1.000",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Manrope',
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ]),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Image.asset(
                'lib/assets/images/image1.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Menus extends StatelessWidget {
  const Menus({
    super.key,
    required this.height,
    required this.width,
    required this.listMenus,
    required this.controller,
    required this.onTap,
  });

  final double height;
  final double width;
  final List<TypeSubmission> listMenus;
  final CarouselSliderController controller;
  final Function(TypeSubmission) onTap;

  @override
  Widget build(BuildContext context) {
    Widget buildItem(TypeSubmission item, {double? itemWidth}) {
      return Container(
        margin: EdgeInsets.only(right: width * .01),
        child: ItemSlider(
          item: item,
          width: itemWidth ?? width,
          onTap: onTap,
          groupText: AutoSizeGroup(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 540) {
          // Desktop layout
          return Container(
            height: height,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: listMenus
                  .map((item) => buildItem(item,
                      itemWidth: (width / listMenus.length) >= 300 //cek ulang
                          ? (width / listMenus.length)
                          : 300))
                  .toList(),
            ),
          );
        } else {
          // Mobile layout
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mulai Pengajuan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Manrope',
                  ),
                ),
                CarouselSlider(
                  carouselController: controller,
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: .8,
                    height: height,
                  ),
                  items: listMenus.map((item) => buildItem(item)).toList(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class ItemSlider extends StatelessWidget {
  const ItemSlider({
    super.key,
    required this.item,
    required this.width,
    required this.onTap,
    required this.groupText,
  });

  final TypeSubmission item;
  final double width;
  final Function(TypeSubmission p1) onTap;
  final AutoSizeGroup groupText;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: item.judul,
      child: SizedBox(
        width: width,
        child: Card(
          child: InkWell(
            onTap: () => {onTap(item)},
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset(
                      item.img_assset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                AutoSizeText(
                  item.judul,
                  group: groupText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text:
                      'Pengajuan Hibah, PKM maupun Insentif menjadi lebih mudah',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Manrope',
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 5),
                ),
                WidgetSpan(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('lib/assets/images/fast.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Header extends StatefulWidget {
  const Header({
    Key? key,
    this.hideChangeMode = false,
    this.changeMode,
    this.notificationTap,
    this.logoutTap,
  }) : super(key: key);

  final bool hideChangeMode;
  final Function()? changeMode;
  final Function()? notificationTap;
  final Function()? logoutTap;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    final levelState = Provider.of<LevelState>(context);

    final userInfo = Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(60),
          ),
          child: Image.asset('lib/assets/images/user.png'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hi, Adam Furqon",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Manrope',
              ),
            ),
            Text(
              levelState.level,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Manrope',
              ),
            ),
          ],
        ),
      ],
    );

    final actionButtons = [
      (!widget.hideChangeMode
          ? IconButton(
              onPressed: widget.changeMode,
              icon: Icon(
                Icons.change_circle,
                size: 26,
                color: Theme.of(context).primaryColor,
              ),
            )
          : const SizedBox.shrink()),
      if (widget.notificationTap != null)
        Stack(
          children: [
            IconButton(
              onPressed: widget.notificationTap,
              icon: Icon(
                Icons.notifications,
                size: 26,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Positioned(
              top: 11,
              right: 11,
              child: RippleAnimation(
                size: const Size(10, 10),
                key: UniqueKey(),
                repeat: true,
                color: Colors.red,
                minRadius: 10,
                ripplesCount: 1,
                duration: const Duration(milliseconds: 2300),
                child: const SmallCircleNotification(),
              ),
            )
          ],
        ),
      if (widget.logoutTap != null)
        IconButton(
          onPressed: widget.logoutTap,
          icon: Icon(
            Icons.logout,
            size: 26,
            color: Theme.of(context).primaryColor,
          ),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: userInfo),
            if (constraints.maxWidth >= 540)
              Row(children: actionButtons)
            else
              Row(children: [actionButtons.first]),
          ],
        );
      },
    );
  }
}
