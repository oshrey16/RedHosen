// import 'dart:io';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:open_file/open_file.dart';

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

  late String fileName;
  List lettersiter = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar:
            AppBar(title: const Text("מנהל חוסן - ראשי"), centerTitle: true),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Column(children: [
            const Text(":טווח תאריכים"),
            SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  fileName = DateTime.now().toString();
                  _generateDoc().then((value) {_openExcel();});
                },
                child: const Text("הפק דוח"),
              ),
            ),
          ])),
        ));
  }

  Future <void> _generateDoc() {
    List<String> dates = _range.split(" - ");
    String fdate = dates[0];
    var dateTime1 = intl.DateFormat('dd/MM/yyyy').parse(fdate);
    String edate = dates[1];
    var dateTime2 = intl.DateFormat('dd/MM/yyyy').parse(edate);
    return FirebaseFirestore.instance
        .collection("Reports")
        .where("time", isGreaterThanOrEqualTo: dateTime1)
        .where("time", isLessThanOrEqualTo: dateTime2)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return _createExcel(value.docs);
      }
      else{
        showDialogMsg(context, MsgType.alert, "לא נמצאו דוחות בתאריכים אלה");
      }
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    String ex = ".xlsx";
    return File('$path/$fileName$ex');
  }

  Future<File> _writeExcel(List<int> bytes) async {
    final file = await _localFile;
    // Write the file
    print("SAVED! path: " + file.path);
    return file.writeAsBytes(bytes);
  }

  Future _openExcel() async {
    try {
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsBytes();
      // file.open();
      await OpenFile.open(file.path.toString());
      return 0;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<void> _createExcel(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    // Create a new Excel document.
    final xls.Workbook workbook = xls.Workbook();
    //Accessing worksheet via index.
    final xls.Worksheet sheet = workbook.worksheets[0];
    //Set titles.
    sheet.getRangeByName('A1').setText('שם נפגע');
    sheet.getRangeByName('B1').setText('טלפון נפגע');
    sheet.getRangeByName('C1').setText('כתובת מגורים');
    sheet.getRangeByName('D1').setText('מספר נפשות בבית');
    sheet.getRangeByName('E1').setText('פרטים על מבוגרים שנפגעו');
    sheet.getRangeByName('F1').setText('פרטים על ילדים שנפגעו');
    sheet.getRangeByName('G1').setText('פרטים על קשישים שנפגעו');
    sheet.getRangeByName('H1').setText('תאור נזק לרכוש');
    sheet.getRangeByName('I1').setText('סוג המענה שניתן בסמוך לאירוע');
    sheet.getRangeByName('J1').setText('פרוט המענה שניתן בסמוך לאירוע וע"י איזה גורם מקצוע');
    sheet.getRangeByName('K1').setText('המלצות להמשך טיפול ו/או מעקב');
    sheet.getRangeByName('L1').setText('הערות ותוספות');
    sheet.getRangeByName('N1:O1').merge();
    sheet.getRangeByName('N1').setText(':תאריך הוצאת הדוח');
    sheet.getRangeByName('N2:O2').merge();
    sheet.getRangeByName('N2').setDateTime(DateTime.now());
    sheet.getRangeByName('N3:O4').merge();
    sheet.getRangeByName('O4').setText('כאן יהיה לוגו');
    // sheet.getRangeByName('N3').setText('כאן יהיה לוגו');
    
    int row = 2;
    for(var d in docs){
      var data = d.data();
      if (data.isNotEmpty){
        int le = data.length;
        for(int i=0;i<data.length;i++){
          print('${lettersiter[i]}$row');
          if(i<=12 && i>=0) {
            if(data[i.toString()] != ""){
              if(i!=9){
              sheet.getRangeByName('${lettersiter[i]}$row').setText(data[i.toString()]);
            }}
            else{
              le++;
            }
          }
        }
      }
    }
    //Set titles.
    // Save the document.
    final List<int> bytes = workbook.saveAsStream();
    _writeExcel(bytes);
    //Dispose the workbook.
    workbook.dispose();
  }
}
