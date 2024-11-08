import 'package:flutter/material.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/Dashboard/DashboardPage.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/InternalResearchCatalogPage.dart';
import 'package:sipaksi/Module/Shared/Module.dart';

List<ItemSidebar> ListItemsSidebar(BuildContext context, Module current) {
  return [
    ItemSidebar(
      title: "Dashboard",
      active: false,
      onTap: () {
        if (current != "dashboard") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardPage(),
            ),
          );
        }
      },
    ),
    ItemSidebar(
      title: Module.insentif.value,
      active: current == Module.insentif,
      onTap: () {
        // if (current != Module.insentif) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const InsentifPage(),
        //     ),
        //   );
        // }
      },
    ),
    ItemSidebar(
      title: Module.penelitian_internal.value,
      active: current == Module.penelitian_internal,
      onTap: () {
        if (current != Module.penelitian_internal) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InternalResearchCatalogPage(),
            ),
          );
        }
      },
    ),
    ItemSidebar(
      title: Module.penelitian_nasional.value,
      active: current == Module.penelitian_nasional,
      onTap: () {
        // if (current != Module.insentif) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const NationalResearchCatalogPage(),
        //     ),
        //   );
        // }
      },
    ),
    ItemSidebar(
      title: Module.pkm_internal.value,
      active: current == Module.pkm_internal,
      onTap: () {
        // if (current != Module.insentif) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const PKMCatalogPage(),
        //     ),
        //   );
        // }
      },
    ),
    ItemSidebar(
      title: Module.pkm_nasional.value,
      active: current == Module.pkm_nasional,
      onTap: () {
        // if (current != Module.insentif) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const PKMNCatalogPage(),
        //     ),
        //   );
        // }
      },
    ),
    ItemSidebar(
      title: Module.ppm.value,
      active: current == Module.ppm,
      onTap: () {
        // if (current != Module.insentif) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const PPMCatalogPage(),
        //     ),
        //   );
        // }
      },
    ),
    ItemSidebar(
      title: Module.notifikasi.value,
      active: current == Module.notifikasi,
      onTap: () {
        // if (current != Module.insentif) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const PPMCatalogPage(),
        //     ),
        //   );
        // }
      },
    ),
  ];
}
