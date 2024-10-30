import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sipaksi/Components/VerticalTimeline/ItemsTimeline.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiDosenPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiMahasiswaMbkmPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiMahasiswaPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/AnggotaPenelitian/AnggotaPenelitiNonDosenPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/DokumenKontrak/DokumenKontrakPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/JudulTahunPenelitian/JudulTahunUsulanPage.dart';
import 'package:sipaksi/Components/VerticalTimeline/Timeline.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/LuaranTambahanPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/LuaranUploadPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Luaran/LuaranWajibPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/PrioritasRiset/PrioritasRisetPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Rab/RabPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/RumpunIlmu/RumpunIlmuPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/SkemaPenelitian/SkemaPenelitianPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Status.dart';
import 'dart:math' as math;

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
        title: "Identitas Usulan Penelitian",
        subItems: [
          ItemsTimeline(
            title: "Judul & Tahun Usulan Penelitian",
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
            title: "Skema Penelitian",
            description:
                "pada tahap ini anda harus menyetor data kategori skema, txt dan kategori tkt yang ingin dicapai",
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
        title: "Pemilihan Program Penelitian",
        subItems: [
          ItemsTimeline(
            title: "Prioritas Riset",
            description:
                "pada tahap ini anda harus menyetor data prioritas riset, bidang fokus penelitian, tema dan topik",
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
            title: "Rumpun Ilmu & Lama Kegiatan",
            description:
                "pada tahap ini anda harus menyetor data rumpun ilmu 1-3 dan lama Kegiatan",
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
        title: "Anggota Peneliti",
        subItems: [
          ItemsTimeline(
            title: "Anggota Peneliti (Dosen)",
            description:
                "pada tahap ini anda harus menyetor data daftar dosen unpak yang berkontribusi dalam penelitian ini",
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
            title: "Anggota Peneliti (Mahasiswa)",
            // description:
            //     "pada tahap ini anda harus menyetor data daftar mahasiswa unpak yang ikut dalam penelitian ini",
            required: true,
            isDone: true,
            action: () {},
            subItems: [
              ItemsTimeline(
                title: "Data Mahasiswa",
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
                title: "Data MBKM",
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
            title: "Anggota Peneliti (Non Dosen)",
            description:
                "pada tahap ini anda harus menyetor data daftar dosen diluar unpak atau bukan dosen yang berkontribusi dalam penelitian ini",
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
        title: "Substansi",
        subItems: [
          ItemsTimeline(
            title: "Unggah Proposal Penelitian",
            description:
                "pada tahap ini anda harus unggah berkas proposal penelitian sesuai template yang telah disediakan",
            required: true,
            isDone: true,
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LuaranUploadPage(),
                ),
              );
            },
            subItems: [],
          ),
          ItemsTimeline(
            title: "Luaran Capaian",
            description:
                "pada tahap ini anda harus menyetor data luaran capaian dan ini sifatnya wajib",
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
            title: "Luaran Capaian Tambahan",
            description:
                "pada tahap ini anda harus menyetor data luaran capaian tambahan dan ini sifatnya opsional. anda melengkapi ini akan medapatkan point lebih selama review lpmp dan reviewer.",
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
        title: "Rencana Anggaran Biaya",
        subItems: [
          ItemsTimeline(
            title: "Data RAB",
            description:
                "pada tahap ini anda harus memberitahu kami rab secara menyeluruh dan lengkap",
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
        title: "Dokumen Pendukung",
        subItems: [
          ItemsTimeline(
            title: "Unggah Dokumen Pendukung",
            description:
                "pada tahap ini anda harus unggah berkas dokumen pendukung dan ini sifatnya opsional",
            required: false,
            isDone: true,
            action: () {},
            subItems: [],
          ),
        ],
      ),
      ItemsTimeline(
        title: "Dokumen Kontrak",
        subItems: [
          ItemsTimeline(
            title: "Unggah Dokumen Kontrak",
            description:
                "pada tahap ini anda harus unggah berkas dokumen kontrak dan ini sifatnya wajib",
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
              isDone: item.isDone,
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

    Status status = Status.parse("tolak_pendanaan");

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              StatusWithHistoryComponent(status: status),
              const SizedBox(height: 5),
              Divider(
                color: Theme.of(context).colorScheme.surfaceDim,
                thickness: 0,
                height: 2,
              ),
              const SizedBox(height: 15),
              const HeaderComponent(),
              const SizedBox(height: 10),
              Timeline(
                hideIndicator: [8],
                indicators: getWidgets("indicator", list, 0),
                children: getWidgets("child", list, 0),
              )
            ],
          ),
        ),
      ),
    );
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
