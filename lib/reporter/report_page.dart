import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:red_hosen/reporter/report_class.dart';
import 'package:red_hosen/mytools.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Text Controllers
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  // User Uid
  late String useruid;
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  // TODO @oshrey16 --> set vesion dynamic
  String _versionreport = "v1";
  // List of Streets
  late List<String> streetList;

  //TextEditingControllers To inputs
  final Map<int, TextEditingController> _textControllers = {};
  // Present fields texts and types value
  Map<int, String> itemsText = {};
  Map<int, String> itemstype = {};
  // Present checkbox texts and selected value
  // {fieldIndex: {checkboxIndex:"TextValue"}}
  Map<int, List<dynamic>> checkboxsText = {};
  Map<int, Map<int, bool>> checkboxsValue = {};

  // Report to Hosen/social
  // institution - From MyTools File
  Map<institution, bool> reportToValue = {
    institution.hosen: false,
    institution.social: false
  };

  @override
  void initState() {
    loadAsset();
    setdatetime();
    setUserName();
    getformat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("דיווח חדש"), centerTitle: true),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
            child: Column(children: [
              const SizedBox(height: 10),
              inputBoxState(_dateController, "תאריך", false),
              const SizedBox(height: 10),
              inputBoxState(_timeController, "שעה", false),
              const SizedBox(height: 10),
              inputBoxState(_nameController, "שם מדווח", false),
              const SizedBox(height: 10),
              SizedBox(width: 200, child: autoCompleteStreet()),
              const SizedBox(height: 15),
              checkboxReportTo(),
              const SizedBox(height: 15),
              FutureBuilder(
                future: getrowsText(),
                builder: (context, snapshot) {
                  return FutureBuilder(
                      future: getrowstype(),
                      builder: (context, snapshot) {
                        return FutureBuilder(
                          future: getrowsCheckboxs(),
                          builder: (context, snapshot) {
                            return buildReport();
                          },
                        );
                      });
                },
              ),
              const SizedBox(height: 15),
              ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 160, height: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const Text("asd")),
                      // );
                      sendReport().then((value) {showDialogMsg(context, MsgType.ok,
                                "הדיווח בוצע בהצלחה")
                            .then((value) => Navigator.pop(context));});
                    },
                    child: const Text("שלח דיווח"),
                  ))
            ])));
  }

  Future sendReport() async {
    String city = "שדרות";
    // var collection = FirebaseFirestore.instance.collection("Reports").add(data)
    String strlocation = _locationController.text;
    List<Location> locations = await locationFromAddress(strlocation + "," + city);
    String time = _timeController.text;
    ReportClass d =
        ReportClass(_versionreport, _textControllers, reportToValue,useruid,strlocation,time,locations[0]);
    d.addReport();
  }

  // Build Report
  // Create Widgets with ReportFormat loaded
  Widget buildReport() {
    return Column(children: [
      for (var item in itemsText.entries)
        if (itemstype[item.key] == "string")
          inputBox(item.key, item.value, true)
        else if (itemstype[item.key] == "checkbox")
          checkboxGrouper(item)
    ]);
  }

  // Create checkboxes for Item in ReportTemplate
  Widget checkboxGrouper(MapEntry<int, String> item) {
    var checkboxitems = checkboxsText[item.key];
    return Column(children: [
      Text(":" + item.value, style: const TextStyle(fontSize: 16)),
      if (checkboxitems != null)
        for (int i = 0; i < checkboxitems.length; i++)
          CheckboxListTile(
              title: Text(checkboxsText[item.key]?[i]),
              checkColor: Colors.white,
              value: checkboxsValue[item.key]?[i],
              onChanged: (bool? value) {
                checkboxsValue[item.key]?[i] = value!;
                setState(() {});
              })
    ]);
  }

  // Create inputBox for Item in ReportTemplate
  Widget inputBox(int key, String title, bool _enabled) {
    _textControllers[key] = TextEditingController();
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Column(
        children: [
          Text(":" + title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          SizedBox(
            width: 200,
            height: 45.0,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                enabled: _enabled,
                maxLength: 45,
                textAlignVertical: TextAlignVertical.center,
                controller: _textControllers[key],
                autofocus: true,
                decoration: InputDecoration(
                  counterText: "",
                  border: const OutlineInputBorder(),
                  labelText: "הקלד " + title,
                ),
              ),
            ),
          ),
        ],
      )
    ]);
  }

  // inputBox - state fields in report
  Widget inputBoxState(
      TextEditingController? controller, String title, bool _enabled) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Column(
        children: [
          Text(":" + title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          SizedBox(
            width: 200,
            height: 45.0,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                enabled: _enabled,
                maxLength: 45,
                textAlignVertical: TextAlignVertical.center,
                controller: controller,
                autofocus: true,
              ),
            ),
          ),
        ],
      )
    ]);
  }

  Widget checkboxReportTo() {
    return Column(children: [
      const Text("דיווח לגורם:", style: TextStyle(fontSize: 16)),
      CheckboxListTile(
          title: const Text("חוסן"),
          checkColor: Colors.white,
          value: reportToValue[institution.hosen],
          onChanged: (bool? value) {
            reportToValue[institution.hosen] = value!;
            setState(() {});
          }),
      CheckboxListTile(
          title: const Text("רווחה"),
          checkColor: Colors.white,
          value: reportToValue[institution.social],
          onChanged: (bool? value) {
            reportToValue[institution.social] = value!;
            setState(() {});
          })
    ]);
  }

  // Load StreetList
  // TODO - Load it in main
  loadAsset() async {
    final myData = await rootBundle.loadString("assets/sderot_streets.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
    // Convert List to 1D list (AutoComplete)
    var list1d = csvTable.expand((x) => x).toList();
    streetList = list1d.cast<String>();
  }

  // AutoComplete Street Widget
  Widget autoCompleteStreet() {
    return Column(children: [
      const Text(":מיקום האירוע", style: TextStyle(fontSize: 16)),
      Directionality(
          textDirection: TextDirection.rtl,
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return streetList.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              _locationController.text = selection;
            },
          ))
    ]);
  }

  // Set Time To this report
  void setdatetime() async {
    final DateTime now = DateTime.now();
    final intl.DateFormat dateformat = intl.DateFormat('dd-MM-yyyy');
    final String formatted = dateformat.format(now);
    _dateController.text = formatted;

    final intl.DateFormat timeformat = intl.DateFormat('hh:mm');
    final String formattedtime = timeformat.format(now);
    _timeController.text = formattedtime;
  }

  // Set Username To this report
  void setUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      useruid = user.uid;
      _nameController.text = user.displayName ?? '';
    }
  }

  // Get Corrent Version Of Template
  void getformat() async {
    FirebaseFirestore.instance
        .collection("ReportTempletes")
        .doc("corrent")
        .get()
        .then((value) => _versionreport = "v" + value.data()?["v"]);
  }

  // Get Text(Translate) of fields From Report Template- FireStore
  Future getrowsText() {
    return FirebaseFirestore.instance
        .collection("ReportTempletes")
        .doc(_versionreport)
        .collection("Translate")
        .doc("Translate")
        .get()
        .then((value) {
      var data = value.data();
      if (data != null) {
        int len = data.length;
        for (int i = 0; i < len; i++) {
          if (data[i.toString()] != null) {
            itemsText[i] = data[i.toString()];
          }
          // deleted value will continue be field on firestore
          else {
            len += 1;
          }
        }
      }
    });
  }

  // Get Types of fields From Report Template- FireStore
  Future getrowstype() {
    return FirebaseFirestore.instance
        .collection("ReportTempletes")
        .doc(_versionreport)
        .collection("Types")
        .doc("Types")
        .get()
        .then((value) {
      var data = value.data();
      if (data != null) {
        int len = data.length;
        for (int i = 0; i < len; i++) {
          if (data[i.toString()] != null) {
            itemstype[i] = data[i.toString()];
          } else {
            len += 1;
          }
        }
      }
    });
  }

  // Get Checkboxs From Report Template- FireStore
  Future getrowsCheckboxs() {
    return FirebaseFirestore.instance
        .collection("ReportTempletes")
        .doc(_versionreport)
        .collection("checkboxs")
        .doc("checkboxs")
        .get()
        .then((value) {
      var data = value.data();
      // print(data);
      if (data != null) {
        for (var checkboxlable in data.entries) {
          var value = data[checkboxlable.key];
          List<String> subchecks = List<String>.from(value as List);
          checkboxsText[int.parse(checkboxlable.key)] = value;
          checkboxsValue[int.parse(checkboxlable.key)] = {};
          for (int j = 0; j < subchecks.length; j++) {
            checkboxsValue[int.parse(checkboxlable.key)]?[j] = false;
          }
        }
      }
    });
  }
}
