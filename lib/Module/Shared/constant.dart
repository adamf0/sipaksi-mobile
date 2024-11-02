import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/Shared/Module.dart';

List<ItemSidebar> ListItemsSidebar(Module current) {
  return [
    ItemSidebar(
      title: Module.insentif.value,
      active: current == Module.insentif,
      onTap: () {},
    ),
    ItemSidebar(
      title: Module.penelitian_internal.value,
      active: current == Module.penelitian_internal,
      onTap: () {},
    ),
    ItemSidebar(
      title: Module.penelitian_nasional.value,
      active: current == Module.penelitian_nasional,
      onTap: () {},
    ),
    ItemSidebar(
      title: Module.pkm_internal.value,
      active: current == Module.pkm_internal,
      onTap: () {},
    ),
    ItemSidebar(
      title: Module.pkm_nasional.value,
      active: current == Module.pkm_nasional,
      onTap: () {},
    ),
    ItemSidebar(
      title: Module.ppm.value,
      active: current == Module.ppm,
      onTap: () {},
    ),
  ];
}
