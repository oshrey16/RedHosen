import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:red_hosen/Reports/report_class_read.dart';
import 'package:intl/intl.dart';
import 'package:red_hosen/mytools.dart';

class ReportRead extends StatefulWidget {
  final String reportid;
  const ReportRead({required this.reportid, Key? key}) : super(key: key);

  @override
  State<ReportRead> createState() => _ReportReadState();
}

class _ReportReadState extends State<ReportRead> {
  late Future<BasicReport> report;
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _numberPeopleController = TextEditingController();
  Map<institution, bool> reportToValue = {};

  late Map<int, TextEditingController> dataControllers = {};
  late Map<int, String> translate;
  @override
  void initState() {
    report = BasicReport.create(widget.reportid);
    report.then((value) {
      setDate(value.time!);
      _nameController.text = value.nameReporter.toString();
      _phoneController.text = value.phoneReporter.toString();
      _numberPeopleController.text = value.numberpeople.toString();
      _locationController.text = value.location.toString();
      for (var v in value.datamap.entries) {
        dataControllers[v.key] = TextEditingController();
        dataControllers[v.key]?.text = v.value;
      }
      translate = value.translate;
      reportToValue = value.reportTo;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("צפיה דוח"), centerTitle: true),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
            child: Center(
                child: Column(children: [
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                lineBlock(_timeController, "שעה", false),
                const SizedBox(width: 10),
                lineBlock(_dateController, "תאריך", false),
              ]),
              const SizedBox(height: 10),
              lineBlock(_nameController, "שם מדווח", false),
              const SizedBox(height: 10),
              lineBlock(_phoneController, "טלפון מדווח", false),
              const SizedBox(height: 10),
              lineBlock(_numberPeopleController, "מספר נפגעים", false),
              const SizedBox(height: 10),
              lineBlock(_locationController, "מיקום", false),
              const SizedBox(height: 10),
              FutureBuilder(
                future: report,
                builder: (context, snapshot) {
                  return buildReport();
                },
              ),
              const Text(":אפשרויות"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _doneReport();
                    },
                    child: const Text("סמן כבטיפול"),
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _doneReport();
                    },
                    child: const Text("סמן כבוצע"),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(reportToValue[institution.hosen] != null){
                        reportToValue[institution.hosen] == false ? null : _doneReport();
                      }
                    },
                    child: reportToValue[institution.hosen] == false ? const Text("דיווח לחוסן") : const Text("דיווח לחוסן",style: TextStyle(decoration: TextDecoration.lineThrough),),
                    style: ElevatedButton.styleFrom(
                        primary: reportToValue[institution.hosen] == false ? Colors.brown.shade400 : Colors.grey),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _doneReport();
                    },
                    child: reportToValue[institution.hosen] == false ? const Text("דיווח לרווחה") : const Text("דיווח לרווחה",style: TextStyle(decoration: TextDecoration.lineThrough),),

                    style: ElevatedButton.styleFrom(
                        primary: reportToValue[institution.hosen] == false ? Colors.brown.shade400 : Colors.grey),
                  ),
                ],
              )
            ]))));
  }

  // Build Report
  // Create Widgets with ReportFormat loaded
  Widget buildReport() {
    return Column(children: [
      reportedtoCheckBox(),
      const SizedBox(height: 10),
      for (var item in dataControllers.entries)
        line2Block(dataControllers[item.key], translate[item.key]!, false)
    ]);
  }

  _doneReport() {
    print("Click");
  }

  // void getReport() {
  //   FirebaseFirestore.instance
  //       .collection("Reports")
  //       .doc(widget.reportid)
  //       .get()
  //       .then((value) {
  //     var data = value.data();
  //     setDate(data!['time'] as Timestamp);
  //     print(data);
  //   });
  // }

  void setDate(DateTime dt) {
    final DateFormat formatterdate = DateFormat('dd-MM-yyyy');
    _dateController.text = formatterdate.format(dt);
    final DateFormat formattertime = DateFormat('hh:mm');
    _timeController.text = formattertime.format(dt);
  }

  // Future getTitles() async {
  //   return await FirebaseFirestore.instance
  //       .collection("ReportTempletes")
  //       .doc(_versionreport)
  //       .collection("Translate")
  //       .doc("Translate")
  //       .get()
  //       .then((value) {
  //     var data = value.data();
  //     if (data != null) {
  //       int len = data.length;
  //       for (int i = 0; i < len; i++) {
  //         if (data[i.toString()] != null) {
  //           itemsText[i] = data[i.toString()];
  //         }
  //         // deleted value will continue be field on firestore
  //         else {
  //           len += 1;
  //         }
  //       }
  //     }
  //   });
  // }

  Widget lineBlock(
      TextEditingController? controller, String title, bool _enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 45.0,
          child: TextField(
            enabled: _enabled,
            maxLength: 45,
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            autofocus: true,
          ),
        ),
        const SizedBox(width: 10),
        Text(":" + title, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget line2Block(
      TextEditingController? controller, String title, bool _enabled) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(":" + title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        SizedBox(
          width: 100,
          height: 45.0,
          child: TextField(
            enabled: _enabled,
            maxLength: 45,
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            autofocus: true,
          ),
        ),
      ],
    );
  }

  Widget reportedtoCheckBox() {
    return Column(children: [
      const Text(":דיווח לגורם", style: TextStyle(fontSize: 16)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        const SizedBox(width: 40),
        Expanded(
          child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text("חוסן"),
              checkColor: Colors.white,
              value: reportToValue[institution.hosen] ?? false,
              onChanged: null),
        ),
        Expanded(
            child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("רווחה"),
                checkColor: Colors.white,
                value: reportToValue[institution.hosen] ?? false,
                onChanged: null))
      ])
    ]);
  }
}
