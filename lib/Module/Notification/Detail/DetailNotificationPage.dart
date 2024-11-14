import 'package:flutter/material.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Module/Notification/Detail/Entity/Issue.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';

class DetailNotificationPage extends StatefulWidget {
  const DetailNotificationPage({super.key});

  @override
  State<DetailNotificationPage> createState() => _DetailNotificationPageState();
}

class _DetailNotificationPageState extends State<DetailNotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Text(
          Module.notifikasi.value,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Content(height: height, width: width),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    Module current = Module.notifikasi;

    return LayoutBuilder(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: width * .01,
                          right: width * .01,
                          top: 10,
                        ),
                        child: StepBreadCrumb.createBreadCrumb(
                            context: context,
                            list: [
                              ItemStepCreadCrumb(
                                icon: Icons.home,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              ItemStepCreadCrumb(
                                title: Module.notifikasi.value,
                                onTap: null,
                              )
                            ]),
                      ),
                      InfoDetail(
                        height: height,
                        width: width,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            child: InfoDetail(
              height: height,
              width: width,
            ),
          );
        }
      },
    );
  }
}

class InfoDetail extends StatefulWidget {
  const InfoDetail({super.key, required this.width, required this.height});

  final double width, height;

  @override
  State<InfoDetail> createState() => _InfoDetailState();
}

class _InfoDetailState extends State<InfoDetail> {
  List<Issue> listIssue = [
    Issue(
      id: 1,
      judul: "Anggota Peneliti",
      spesifik: "Data MBKM",
      tanggal_keterangan: "Pengajuan Ditolak 01 Desember 2024",
    ),
    Issue(
      id: 2,
      judul: "Dokumen Pendukung",
      tanggal_keterangan: "Pengajuan Ditolak 01 Desember 2024",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Masalah Penolakan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Pengajuan anda memiliki masalah kebijakan sehingga pengajuan anda ditolak. Perbaiki masalah yang disebutkan dan pastikan pembetulan sesuai sudah sesuai sebelum di submit.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: Row(
              children: [
                const Icon(
                  Icons.info_rounded,
                  color: Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pengajuan Ditolak',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...listIssue
              .map(
                (issue) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          issue.judul,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          issue.spesifik ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          issue.tanggal_keterangan,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Implement navigation or action here
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
