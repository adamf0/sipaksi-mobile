import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sipaksi/Module/ColorExtension.dart';
import 'package:sipaksi/Module/Shared/FooterAction.dart';
import 'package:table_calendar/table_calendar.dart';

class JudulTahunUsulanPage extends StatefulWidget {
  const JudulTahunUsulanPage({super.key});

  @override
  State<JudulTahunUsulanPage> createState() => _JudulTahunUsulanPageState();
}

class _JudulTahunUsulanPageState extends State<JudulTahunUsulanPage> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () =>
              !isLoading.value ? Navigator.of(context).pop() : null,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Hero(
          tag: "Judul & Tahun Penelitian",
          child: Text(
            "Judul & Tahun Penelitian",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      decoration: InputDecoration(
                        errorText: "belum diisi",
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 6),
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
                      selectedDayPredicate: (day) =>
                          isSameDay(day, _selectedDay),
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
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
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
            isLoading: isLoading,
            optionalBuilder: (height) => Container(),
            onPress: (double height) {
              if (!isLoading.value) {
                isLoading.value = true;
                Future.delayed(const Duration(seconds: 2), () {
                  isLoading.value = false;
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
      ),
    );
  }
}
