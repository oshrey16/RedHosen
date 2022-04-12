import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);
  @override
  State<ReportPage> createState() => _ReportPageState();
}

Map<int, Map<int, bool>> checkboxsValue = {};

class _ReportPageState extends State<ReportPage> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
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
  Map<int, List<dynamic>> checkboxsText = {};

  bool che = false;
  List c = [];

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
              const SizedBox(height: 15),
              inputBoxState(_dateController, "תאריך", false),
              const SizedBox(height: 15),
              inputBoxState(_timeController, "שעה", false),
              const SizedBox(height: 15),
              inputBoxState(_nameController, "שם מדווח", false),
              const SizedBox(height: 15),
              inputBoxLocation(_locationController),
              const SizedBox(height: 15),
              AutoTest(),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Text("asd")),
                      );
                    },
                    child: const Text("שלח דיווח"),
                  ))
            ])));
  }

  Widget buildReport() {
    return Column(children: [
      for (var item in itemsText.entries)
        if (itemstype[item.key] == "string")
          inputBox(_textControllers[item.key], item.value, true)
        else if (itemstype[item.key] == "checkbox")
          checkboxGrouper(item)
    ]);
  }

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
      // else if (itemstype[item.key] == "checkbox")
      // loginRegline(_textControllers[item.key], "MA", true)
    ]);
  }

  Widget inputBox(
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
              textDirection: TextDirection.ltr,
              child: TextField(
                enabled: _enabled,
                maxLength: 45,
                textAlignVertical: TextAlignVertical.center,
                controller: controller,
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
              textDirection: TextDirection.ltr,
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

  Widget inputBoxLocation(TextEditingController? controller) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Column(children: [
        const Text(":מיקום", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        SizedBox(
          width: 200,
          height: 45.0,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: TextField(
              maxLength: 60,
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                counterText: "",
                border: OutlineInputBorder(),
                labelText: "הקלד מיקום",
              ),
              onChanged: (value) async {
                // TODO
                // List<Location> locations = await locationFromAddress(value);
                // print(locations[0].latitude);
                print("OK");
              },
            ),
          ),
        ),
      ])
    ]);
  }

  loadAsset() async {
    final myData = await rootBundle.loadString("assets/sderot_streets.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
    // Convert List to 1D list (AutoComplete)
    var list1d = csvTable.expand((x) => x).toList();
    streetList = list1d.cast<String>();
  }

  Widget AutoTest() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return streetList.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }

  void setdatetime() async {
    final DateTime now = DateTime.now();
    final intl.DateFormat dateformat = intl.DateFormat('dd-MM-yyyy');
    final String formatted = dateformat.format(now);
    _dateController.text = formatted;

    final intl.DateFormat timeformat = intl.DateFormat('hh:mm');
    final String formattedtime = timeformat.format(now);
    _timeController.text = formattedtime;
  }

  void setUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
    }
  }

  void getformat() async {
    FirebaseFirestore.instance
        .collection("ReportTempletes")
        .doc("corrent")
        .get()
        .then((value) => _versionreport = "v" + value.data()?["v"]);
  }

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
