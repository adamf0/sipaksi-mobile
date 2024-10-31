import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sipaksi/Module/Dashboard/TypeSubmission.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/InternalResearchCatalogPage.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late CarouselSliderController innerCarouselController;
  int innerCurrentPage = 0;

  @override
  void initState() {
    super.initState();
    innerCarouselController = CarouselSliderController();
  }

  @override
  void dispose() {
    // innerCarouselController.dispose(); // Dispose the controller if needed
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
        judul: "Penelitian Internal",
        img_asset: 'lib/assets/images/microscope.png',
      ),
      TypeSubmission(
        judul: "Penelitian Nasional",
        img_asset: 'lib/assets/images/national.png',
      ),
      TypeSubmission(
        judul: "PKM Internal",
        img_asset: 'lib/assets/images/creativity.png',
      ),
      TypeSubmission(
        judul: "PKM Nasional",
        img_asset: 'lib/assets/images/compotitive.png',
      ),
      TypeSubmission(
        judul: "PPM",
        img_asset: 'lib/assets/images/international.png',
      ),
    ];

    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
      // appBar: AppBar(),
      extendBodyBehindAppBar: false,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.question_answer,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: Theme.of(context).primaryColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Header(),
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
              IdSintaCard(height: height, IdSinta: "123"),
              const SizedBox(height: 5),
              JabatanFungsionalCard(height: height),
              const SizedBox(height: 10),
              Menus(
                height: height,
                width: width,
                listMenus: listMenus,
                controller: innerCarouselController,
                onTap: (tap) {
                  if (tap.judul == "Penelitian Internal") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const InternalResearchCatalogPage(),
                      ),
                    );
                  }
                  // setState(() {
                  //   innerCurrentPage = index;
                  // });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JabatanFungsionalCard extends StatelessWidget {
  const JabatanFungsionalCard({
    super.key,
    required this.height,
  });

  final double height;

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
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
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
            // SizedBox or fixed height to prevent RenderBox error
            SizedBox(
              height: height * .12,
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
    required this.height,
    this.IdSinta,
  });

  final double height;
  final String? IdSinta;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
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
            // SizedBox or fixed height to prevent RenderBox error
            SizedBox(
              height: height * .12,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
              viewportFraction: .6,
              height: height * .15,
              onPageChanged: (index, reason) {
                // onPageChanged(index);
              },
            ),
            items: listMenus.map((item) {
              return Builder(
                builder: (BuildContext context) {
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Image.asset(
                                    item.img_assset,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Text(item.judul),
                              const SizedBox(height: 10)
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
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

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, Adam Furqon",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Manrope',
                    ),
                  ),
                  Text(
                    "Dosen",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(
          Icons.change_circle,
          size: 26,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
