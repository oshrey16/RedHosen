import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' as intl;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:numberpicker/numberpicker.dart';
import 'package:red_hosen/reporter/report_class.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool loadingLocation = false;
  // Text Controllers
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  // User Uid
  late String useruid;
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _homeNumber = TextEditingController();
  // TODO @oshrey16 --> set vesion dynamic
  String _versionreport = "v1";
  // List of Streets
  late List<String> streetList;
  String priorityValue = "נמוך";

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
  late Future ssss;
  int _numberPeople = 0;

  // Speech To Text
  final SpeechToText _speechToText = SpeechToText();
  int selectdSpeechTotext = -1;
  Map<int, Color> micColoricon = {};
  bool available = false;
  String _SavedText = "";
  late AnimationController _controllera;

  @override
  void initState() {
    loadAsset();
    ssss = start();
    setdatetime();
    setUserName();
    getformat();
    // _initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(title: const Text("דיווח חדש"), centerTitle: true),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 10, 30, 0),
            child: Center(
                child: Column(children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  inputBoxState(_dateController, "תאריך", false),
                  const SizedBox(width: 10),
                  inputBoxState(_timeController, "שעה", false),
                ],
              ),
              const SizedBox(height: 10),
              inputBoxState(_nameController, "שם מדווח", false),
              const SizedBox(height: 10),
              Container(width: MediaQuery. of(context). size. width/1.2, child: 
              autoCompleteStreet(),),
              const SizedBox(height: 10),
              inputBoxStateSmall(_homeNumber, "בניין/בית"),
              const SizedBox(height: 15),
              checkboxReportTo(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text("מספר נפגעים"),
                      NumberPicker(
                        value: _numberPeople,
                        minValue: 0,
                        maxValue: 20,
                        itemWidth: 30,
                        itemHeight: 30,
                        onChanged: (value) =>
                            setState(() => _numberPeople = value),
                      ),
                    ],
                  ),
                  // SizedBox(width: 30),
                  inputPriority(),
                ],
              ),
              const SizedBox(height: 15),
              FutureBuilder(
                future: ssss,
                builder: (context, snapshot) {
                  return buildReport();
                },
              ),
              const SizedBox(height: 15),
              ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 160, height: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      sendReport().then((value) {
                        if (value == true) {
                          showDialogMsg(
                                  context, MsgType.ok, "הדיווח בוצע בהצלחה")
                              .then((value) => Navigator.pop(context));
                        }
                      });
                    },
                    child: const Text("שלח דיווח"),
                  ))
            ]))));
  }

  Future sendReport() async {
    String city = "שדרות";
    if (validReport() == true) {
      // var collection = FirebaseFirestore.instance.collection("Reports").add(data)
      String strlocation = _locationController.text;
      List<Location> locations =
          await locationFromAddress(strlocation + "," + city);
      String time = _timeController.text;
      ReportClass d = ReportClass(
          _versionreport,
          _textControllers,
          checkboxsValue,
          reportToValue,
          useruid,
          strlocation,
          time,
          locations[0],
          priorityValue,
          _numberPeople);
      return d.addReport().then((value) {
        return Future<bool>.value(true);
      });
    } else {
      return Future<bool>.value(false);
    }
  }

  Future start() {
    return getrowsText().then((value) => getrowstype().then(
        (value) => getrowsCheckboxs().then((value) => buildReportBuild())));
  }

  bool validReport() {
    if (_locationController.text == "") {
      showDialogMsg(context, MsgType.error, "אנא הזן כתובת");
      return false;
    }
    if (_homeNumber.text == "") {
      showDialogMsg(context, MsgType.error, "אנא הזן מספר בית/בניין");
      return false;
    }
    bool ok = false;
    for (var v in reportToValue.values) {
      if (v == true) {
        ok = true;
      }
    }
    if (ok == false) {
      showDialogMsg(context, MsgType.error, "עליך לסמן גורם לדיווח");
      return false;
    }
    if (_numberPeople == 0) {
      showDialogMsg(context, MsgType.error, "אנא בחר מספר נפגעים");
      return false;
    }
    return true;
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

  Future buildReportBuild() async {
    for (var item in itemsText.entries) {
      if (itemstype[item.key] == "string") {
        _textControllers[item.key] = TextEditingController();
        // Change Colors in Microphone Icon
        micColoricon[item.key] = Colors.black;
      }
    }
  }

  // Create checkboxes for Item in ReportTemplate
  Widget checkboxGrouper(MapEntry<int, String> item) {
    var checkboxitems = checkboxsText[item.key];
    return Column(children: [
      Text(item.value + " :", style: const TextStyle(fontSize: 16)),
      if (checkboxitems != null)
        for (int i = 0; i < checkboxitems.length; i++)
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const SizedBox(width: 40),
            Expanded(
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(checkboxsText[item.key]?[i]),
                    checkColor: Colors.white,
                    value: checkboxsValue[item.key]?[i],
                    onChanged: (bool? value) {
                      if (value != null) {
                        print(value);
                        setState(() {
                          checkboxsValue[item.key]![i] = value;
                        });
                      }
                    }))
          ])
    ]);
  }

  void _initAndStartSpeech(int key) async {
    if (!available) {
      available = await _speechToText.initialize(
          onStatus: statusListener, onError: errorListener);
      setState(() {});
    } else {
      _startListening();
      setState(() {
        selectdSpeechTotext = key;
        micColoricon[key] = Colors.green;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      if (_textControllers[selectdSpeechTotext]!.text != "") {
        _textControllers[selectdSpeechTotext]!.text =
            _SavedText + " " + result.recognizedWords;
      } else {
        _textControllers[selectdSpeechTotext]!.text =
            _SavedText + result.recognizedWords;
      }
    });
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    if (available) {
      await _speechToText.listen(onResult: _onSpeechResult, localeId: "he");
    }
    setState(() {
      _SavedText = _textControllers[selectdSpeechTotext]!.text;
    });
  }

  void statusListener(str) {
    if (str == "notListening") {
      setState(() {
        micColoricon[selectdSpeechTotext] = Colors.black;
      });
    }
    print(str);
  }

  void errorListener(str) {
    setState(() {
      micColoricon[selectdSpeechTotext] = Colors.black;
    });
    print(str);
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening(int key) async {
    await _speechToText.stop();
    setState(() {
      selectdSpeechTotext = -1;
      micColoricon[key] = Colors.black;
    });
  }

  // Create inputBox for Item in ReportTemplate
  Widget inputBox(int key, String title, bool _enabled) {
    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      child: IconButton(
                          icon: const Icon(Icons.mic_none),
                          color: micColoricon[key],
                          onPressed: () {}),
                      onLongPress: () {
                        _initAndStartSpeech(key);
                      },
                      onLongPressEnd: (LongPressEndDetails details) {
                        _stopListening(key);
                      },
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(title + " :", style: const TextStyle(fontSize: 16)),
                  ],
                ),
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
                // ),
              ],
            )
          ])
        ]));
  }

  // inputBox - state fields in report
  Widget inputBoxState(
      TextEditingController? controller, String title, bool _enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title + " :", style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          height: 45.0,
          // child: Directionality(
          //   textDirection: TextDirection.rtl,
          child: TextField(
            enabled: _enabled,
            maxLength: 45,
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            autofocus: true,
          ),
        ),
        // ),
      ],
    );
  }

  Widget inputBoxStateSmall(TextEditingController? controller, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title + " :", style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        SizedBox(
          width: 60,
          height: 45.0,
          // child: Directionality(
          //   textDirection: TextDirection.rtl,
          child: TextField(
            decoration: const InputDecoration(hintText: "", counterText: ""),
            maxLength: 5,
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            autofocus: true,
          ),
        ),
        // ),
      ],
    );
  }

  Widget checkboxReportTo() {
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
              value: reportToValue[institution.hosen],
              onChanged: (bool? value) {
                reportToValue[institution.hosen] = value!;
                setState(() {});
              }),
        ),
        Expanded(
            child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("רווחה"),
                checkColor: Colors.white,
                value: reportToValue[institution.social],
                onChanged: (bool? value) {
                  reportToValue[institution.social] = value!;
                  setState(() {});
                }))
      ])
    ]);
  }

  Widget inputPriority() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Column(children: [
        const Text("רמת החומרה:", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        DropdownButton<String>(
          value: priorityValue,
          icon: const Icon(Icons.touch_app_rounded),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              priorityValue = newValue!;
            });
          },
          items: <String>['גבוה', 'בינוני', 'נמוך']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ])
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
      const Text("מיקום:", style: TextStyle(fontSize: 16)),
      LayoutBuilder(
        builder: (context, constraints) => Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return streetList.where((String option) {
              return option.contains(textEditingValue.text);
            });
          },
          onSelected: (String selection) {
            _locationController.text = selection;
          },
          // TextField Widget
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) =>
                  TextField(
            showCursor: true,
            autofocus: true,
            controller: textEditingController..text = _locationController.text,
            decoration: InputDecoration(
                hintText: 'הקלד כתובת',
                suffixIconConstraints:
                    const BoxConstraints(maxHeight: 40, maxWidth: 40),
                suffixIcon: !loadingLocation
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            loadLocation();
                          });
                        },
                        icon: const Icon(Icons.location_searching),
                        color: loadingLocation ? Colors.green : Colors.black,
                      )
                    : const spinkit.SpinKitRipple(color: Colors.red)),
            onChanged: (text) {
              _locationController.text = text;
            },
            focusNode: focusNode,
          ),
          // OptionList Widget
          optionsViewBuilder: (context, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              color:Colors.grey.shade200,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(4.0)),
              ),
              child: SizedBox(
                height: 52.0 * options.length,
                width: constraints.biggest.width,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Future loadLocation() {
    setState(() {
      loadingLocation = true;
    });
    return (_determinePosition().then((value) async {
      final translator = GoogleTranslator();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      String street = placemarks[0].street!;
      street = street.replaceAll(RegExp('[0-9]'), '');
      return await translator.translate(street, to: 'iw').then(
        (value) {
          _locationController.text = value.text;
          _homeNumber.text = placemarks[0].name!;
          setState(() {
            loadingLocation = false;
          });
        },
      );
    }));
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
  Future getrowsText() async {
    return await FirebaseFirestore.instance
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
  Future getrowstype() async {
    return await FirebaseFirestore.instance
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
  Future getrowsCheckboxs() async {
    return await FirebaseFirestore.instance
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

  // GetLocation
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
