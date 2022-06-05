import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late String useruid;
  final Map<String, Map<String, dynamic>> test = {};
  bool _isLoading = true;
  intl.DateFormat myformatDate = intl.DateFormat('yyyy-MM-dd | kk:mm');

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(title: const Text("הדיווחים"), centerTitle: true),
        body: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Row(
              // textDirection: TextDirection.rtl,
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
              visible: visibledatepicker,
              child: Column(
                // textDirection: TextDirection.rtl,
                children: [
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
                    ),
                  ),
                  // )
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
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _isLoading ? const Center(child: CircularProgressIndicator()) : generateCards()
        ]));
  }

  Widget generateCards() {
    return Expanded(
        child: Container(width: MediaQuery.of(context).size.width * 0.6, child:ListView(
            children: [for (var item in test.entries) generateCard(item.key)])));
  }

  Widget generateCard(String key) {
    return Card(
        elevation: 8.0,
        color: Colors.white30,
        child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Column(textDirection: TextDirection.ltr,
                // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                children: [
                  Text("תאריך ושעה: ${test[key]!["time"]}"),
                  Text("כתובת: ${test[key]!["location"]}"),
                  Text("דרגת החומרה: ${test[key]!["priority"]}")
                ])));
  }

  Future<void> getReports() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      useruid = user.uid;
      FirebaseFirestore.instance
          .collection("Reports")
          .where("useruid", isEqualTo: useruid)
          .get()
          .then((value) {
        Map<String, dynamic> allData = {};
        for (var report in value.docs) {
          allData[report.id] = report.data();
        }
        for (var element in allData.entries) {
          test[element.key] = <String, dynamic>{};
          // elements to show in page
          test[element.key]?["location"] = element.value['location'];
          test[element.key]?["points"] = element.value['points'];
          test[element.key]?["priority"] = element.value['priority'];

          test[element.key]?["time"] = myformatDate
              .format((element.value['time'] as Timestamp).toDate());
          test[element.key]?["numberpeople"] = element.value['numberpeople'];
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
