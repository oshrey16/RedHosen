import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:red_hosen/Reports/report_class_read.dart';
import 'package:intl/intl.dart' as intl;
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
        dataControllers[v.key]?.text = v.value.toString();
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
              // Buttons
              const Text(":אפשרויות"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _inProgress().then((value) => showDialogMsg(context,MsgType.ok,"סטטוס הדיווח - בטיפול"));
                    },
                    child: const Text("סמן כבטיפול"),
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _done().then((value) => showDialogMsg(context,MsgType.ok,"האירוע נסגר"));
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
                        reportToValue[institution.hosen] == false ? null : _reportToSocial();
                      }
                    },
                    child: reportToValue[institution.hosen] == false ? const Text("דיווח לחוסן") : const Text("דיווח לחוסן",style: TextStyle(decoration: TextDecoration.lineThrough),),
                    style: ElevatedButton.styleFrom(
                        primary: reportToValue[institution.hosen] == false ? Colors.brown.shade400 : Colors.grey),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if(reportToValue[institution.social] != null){
                      reportToValue[institution.social] == false ? null :_reportToHosen();
                      }
                    },
                    child: reportToValue[institution.social] == false ? const Text("דיווח לרווחה") : const Text("דיווח לרווחה",style: TextStyle(decoration: TextDecoration.lineThrough),),

                    style: ElevatedButton.styleFrom(
                        primary: reportToValue[institution.social] == false ? Colors.brown.shade400 : Colors.grey),
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

  Future _done() {
    return report.then((value) => value.doneReport());
  }
  Future _inProgress(){
     return report.then((value) => value.inProgressReport());
  }
  _reportToSocial(){

  }
  _reportToHosen(){
    
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
        return FittedBox(
            fit: BoxFit.fitWidth, child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Column(
        children: [
          Text(":" + title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Directionality(
              textDirection: TextDirection.rtl,
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
          ),
        ],
      )
    ]));
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
