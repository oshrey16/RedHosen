import 'package:flutter/material.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyReports extends StatefulWidget {
  const MyReports({Key? key}) : super(key: key);

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  bool visibledatepicker = false;
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            '${intl.DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${intl.DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: NavDrawer(),
        appBar: AppBar(
          title: const Text("הדיווחים"),
          centerTitle: true,
        ),
        body: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("לפי זמן"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("פתוחים"),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 30,
                  width: 110,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        visibledatepicker = !visibledatepicker;
                      });
                    },
                    child: const Text("תאריכים"),
                  ),
                ),
              ]),
          AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: visibledatepicker ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Visibility(
              child: Column(
                textDirection: TextDirection.rtl,
                children: [
                  const Text(":טווח תאריכים"),
                  Positioned(
                      left: 0,
                      top: 80,
                      right: 0,
                      bottom: 0,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: SfDateRangePicker(
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode: DateRangePickerSelectionMode.range,
                          initialSelectedRange: PickerDateRange(
                              DateTime.now().subtract(const Duration(days: 4)),
                              DateTime.now().add(const Duration(days: 3))),
                        ),
                      )),
                  SizedBox(
                    height: 30,
                    width: 110,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          visibledatepicker = !visibledatepicker;
                        });
                      },
                      child: const Text("סנן"),
                    ),
                  ),
                ],
              ),
              visible: visibledatepicker,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: ListView(children:[ Column(
            children: [for (int i=0;i<5;i++)generateCards(), const Text("בדיקה")],
          )])),
        ]));
  }

  Widget generateCards() {
    return Card(
        elevation: 8.0,
        color: Colors.amberAccent.shade400,
        child: Container(
            width: MediaQuery.of(context).size.width/2,
            padding: const EdgeInsets.all(4.0),
            child: Column(textDirection: TextDirection.ltr, children: [Text(":תאריך דיווח"),Text(":כתובת")])));
  }
}
