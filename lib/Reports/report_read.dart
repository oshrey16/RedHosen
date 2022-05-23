import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:red_hosen/Reports/report_class_read.dart';
import 'package:intl/intl.dart' as intl;
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:red_hosen/global.dart' as global;

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
  Map<institution, int> status = {};
  institution ins = global.getinstitution();

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
        dataControllers[v.key]?.text = v.value.toString();
      }
      translate = value.translate;
      reportToValue = value.reportTo;
      status = value.status;
      print(reportToValue);
      print(ins);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
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
                  return Column(children: [
                    buildReport(),
                    // Buttons
                    const Text(":אפשרויות"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // IN PROGREES Event
                        ElevatedButton(
                          onPressed: () {
                            if (status[ins] == 0) {
                              _inProgress().then((value) => showDialogMsg(
                                  context,
                                  MsgType.ok,
                                  "סטטוס הדיווח - בטיפול"));
                            }
                          },
                          child: status[ins] == 0
                              ? const Text("סמן כבטיפול")
                              : const Text("סמן כבטיפול",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough)),
                          style: status[ins] == 0
                              ? ElevatedButton.styleFrom(primary: Colors.amber)
                              : ElevatedButton.styleFrom(primary: Colors.grey),
                        ),
                        const SizedBox(width: 20),
                        // CLOSE Event
                        ElevatedButton(
                          onPressed: () {
                            if (status[ins] == 1 || status[ins] == 0) {
                              _done().then((value) => showDialogMsg(
                                  context, MsgType.ok, "האירוע נסגר"));
                            }
                          },
                          child: status[ins] == 0 || status[ins] == 1
                              ? const Text("סמן כבוצע")
                              : const Text("סמן כבוצע",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough)),
                          style: status[ins] == 0 || status[ins] == 1
                              ? ElevatedButton.styleFrom(primary: Colors.green)
                              : ElevatedButton.styleFrom(primary: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (reportToValue[institution.hosen] != null) {
                              reportToValue[institution.hosen] == false
                                  ? null
                                  : _reportToHosen().then((value) {
                                      setState(() {});
                                      showDialogMsg(context, MsgType.ok,
                                          "הדיווח למרכז חוסן בוצע בהצלחה");
                                    });
                            }
                          },
                          child: reportToValue[institution.hosen] == false
                              ? const Text("דיווח לחוסן")
                              : const Text(
                                  "דיווח לחוסן",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                          style: ElevatedButton.styleFrom(
                              primary: reportToValue[institution.hosen] == false
                                  ? Colors.brown.shade400
                                  : Colors.grey),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (reportToValue[institution.social] != null) {
                              reportToValue[institution.social] == false
                                  ? _reportToSocial().then((value) {
                                      // setState(() {});
                                      showDialogMsg(context, MsgType.ok,
                                          "הדיווח לאגף הרווחה בוצע בהצלחה");
                                    })
                                  : null;
                            }
                          },
                          child: reportToValue[institution.social] == false
                              ? const Text("דיווח לרווחה")
                              : const Text(
                                  "דיווח לרווחה",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                          style: ElevatedButton.styleFrom(
                              primary:
                                  reportToValue[institution.social] == false
                                      ? Colors.brown.shade400
                                      : Colors.grey),
                        ),
                      ],
                    ),
                  ]);
                },
              ),
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

  Future _done() {
    setState(() {
      status[ins] = 2;
    });
    return report.then((value) => value.doneReport());
  }

  Future _inProgress() {
    setState(() {
      status[ins] = 1;
    });
    return report.then((value) => value.inProgressReport());
  }

  Future _reportToSocial() async {
    setState(() {
      reportToValue[institution.social] = true;
    });
    return updateReportTo();
  }

  _reportToHosen() async {
    setState(() {
      reportToValue[institution.hosen] = true;
    });
    return updateReportTo();
  }

  Future updateReportTo() async {
    final Map<String, bool> m = {
      "hosen": reportToValue[institution.hosen]!,
      "social": reportToValue[institution.social]!
    };
    return await FirebaseDatabase.instance
        .ref("activeReports")
        .child(widget.reportid)
        .update({"ReportTo": m});
  }

  Future updateStatus() async {
    final Map<String, bool> m = {
      "hosen": reportToValue[institution.hosen]!,
      "social": reportToValue[institution.social]!
    };
    return await FirebaseDatabase.instance
        .ref("activeReports")
        .child(widget.reportid)
        .update({"Status": m});
  }

  void setDate(DateTime dt) {
    final intl.DateFormat formatterdate = intl.DateFormat('dd-MM-yyyy');
    _dateController.text = formatterdate.format(dt);
    final intl.DateFormat formattertime = intl.DateFormat('hh:mm');
    _timeController.text = formattertime.format(dt);
  }

  Widget lineBlock(
      TextEditingController? controller, String title, bool _enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title + " :", style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
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

  Widget line2Block(
      TextEditingController? controller, String title, bool _enabled) {
    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Column(
            children: [
              Text(title + " :", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                // child: Directionality(
                //   textDirection: TextDirection.rtl,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 170.0,
                  ),
                  child: TextField(
                    maxLines: null,
                    enabled: _enabled,
                    maxLength: 180,
                    textAlignVertical: TextAlignVertical.center,
                    controller: controller,
                  ),
                ),
              ),
              // ),
            ],
          )
        ]));
  }

  Widget reportedtoCheckBox() {
    return Column(children: [
      const Text("דיווח לגורם:", style: TextStyle(fontSize: 16)),
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
