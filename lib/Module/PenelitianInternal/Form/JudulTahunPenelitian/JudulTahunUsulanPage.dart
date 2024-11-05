import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sipaksi/Components/BreadCrumb/BreadCrumbBuilder.dart';
import 'package:sipaksi/Components/Sidebar/SidebarBuilder.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/JudulTahunPenelitian/Provider/LoadingSaveJudulTahunUsulanState.dart';
import 'package:sipaksi/Module/PenelitianInternal/NameTimeline.dart';
import 'package:sipaksi/Module/Shared/DefaultState.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:sipaksi/Module/Shared/LoadingManager.dart';
import 'package:sipaksi/Module/Shared/Module.dart';
import 'package:sipaksi/Module/Shared/constant.dart';
import 'package:table_calendar/table_calendar.dart';

class JudulTahunUsulanPage extends StatefulWidget {
  const JudulTahunUsulanPage({super.key});

  @override
  State<JudulTahunUsulanPage> createState() => _JudulTahunUsulanPageState();
}

class _JudulTahunUsulanPageState extends State<JudulTahunUsulanPage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;

    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Module current = Module.penelitian_internal;

    return ChangeNotifierProvider(
      create: (context) => LoadingSaveJudulTahunUsulanState(),
      child: Scaffold(
        appBar: AppBar(
          leading: LayoutBuilder(
            builder: (context, constraints) {
              final loadingState =
                  Provider.of<LoadingSaveJudulTahunUsulanState>(context);

              return constraints.maxWidth >= 640
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
            tag: NameTimeline.step1_1.title,
            child: Text(
              NameTimeline.step1_1.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 640) {
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
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();

    _focusedDay = DateTime.parse("2024-01-01");
    _firstDay = DateTime.now().subtract(const Duration(days: 3650));
    _lastDay = DateTime.now().add(const Duration(days: 3650));
    _selectedDay = DateTime.parse("2024-01-01");
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = Provider.of<LoadingSaveJudulTahunUsulanState>(context);
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
                      return constraints.maxWidth >= 640
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
                                      title: NameTimeline.step1_1.title,
                                      onTap: null,
                                    ),
                                  ]),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  Text(
                    "Judul Penelitian",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    onChanged: (value) => {},
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                    decoration: InputDecoration(
                      errorText: "belum diisi",
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tahun Usulan Kegiatan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TableCalendar(
                    calendarFormat: _calendarFormat,
                    availableCalendarFormats: const {
                      CalendarFormat.month: "Month"
                    },
                    onFormatChanged: (format) {},
                    focusedDay: _focusedDay,
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      weekendTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      headerTitleBuilder: (context, day) {
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(DateFormat('dd/MMMM/yyyy').format(day)),
                        );
                      },
                    ),
                  ),
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
