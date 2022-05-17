import 'package:flutter/material.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart' as intl;

class ExportReportsPage extends StatefulWidget {
  const ExportReportsPage({Key? key}) : super(key: key);

  @override
  State<ExportReportsPage> createState() => _ExportReportsPageState();
}

class _ExportReportsPageState extends State<ExportReportsPage> {
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
        drawer: NavDrawer(),
        appBar: AppBar(
          title: const Text("מנהל חוסן - ראשי"),
          centerTitle: true
        ),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Column(children: [
            const Text(":טווח תאריכים"),
            Positioned(
                left: 0,
                top: 80,
                right: 0,
                bottom: 0,
                // child: Directionality(
                //   textDirection: TextDirection.rtl,
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3))),
                  // ),
                )),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {print(_selectedDate);},
                child: const Text("הפק דוח"),
              ),
            ),
          ])),
        ));
  }
}
