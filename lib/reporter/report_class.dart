import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoding/geocoding.dart';
import 'package:red_hosen/mytools.dart';

class ReportClass {
  Map<String, dynamic> fields = {};
  late String version;
  // final Map<institution,bool> reportToValue;
  late Map<String, bool> reportTo = {};
  final String useruid; 
  final String location;
  final String time;
  final Location points;
  final String priorityValue;
  final int numberpeople;


  ReportClass(this.version, Map<int, TextEditingController> textControllers,Map<int, Map<int, bool>> checkboxsValue,
      reportToValue, this.useruid, this.location, this.time, this.points, this.priorityValue, this.numberpeople) {
        DateTime now = DateTime.now();
    castControllers(textControllers);
    castCheckBoxes(checkboxsValue);
    castReportTo(reportToValue);
    fields['version'] = version;
    fields['useruid'] = useruid;
    fields['location'] = location;
    fields['time'] = now;
    GeoPoint googlepoints = GeoPoint(points.latitude, points.longitude);
    fields['points'] = googlepoints;
    fields['priority'] = priorityValue;
    fields['numberpeople'] = numberpeople;
  }

  /// Cast Controllers To <string,dynamic>
  castControllers(Map<int, TextEditingController> textControllers) {
    textControllers.forEach((k, v) {
      fields[k.toString()] = v.text;
    });
  }

  castCheckBoxes(Map<int, Map<int, bool>> checkboxsValue){
    Map<String, Map<String, bool>> checkboxesval = {};
    checkboxsValue.forEach((k, v) {
      checkboxesval[k.toString()] = {};
      v.forEach((key, value) {
        checkboxesval[k.toString()]![key.toString()] = value;
      });
      fields[k.toString()] = checkboxesval[k.toString()];
    });
  }

  castReportTo(Map<institution, bool> reportToValue) {
    reportToValue.forEach((k, v) {
      reportTo[k.name] = v;
    });
  }

  /// Add Report To Firestore
  /// insert report to realtime DB with id in firestore
  Future addReport() async {
    Map<String, int> status = {"hosen": 0,"social" : 0};
    Map<String, dynamic> assignment = {"hosen": "null","social": "null"};
    return FirebaseFirestore.instance
        .collection("Reports")
        .add(fields)
        .then((value) async {
      return FirebaseDatabase.instance.ref("activeReports").child(value.id).set({
        "ReportTo": reportTo,
        "Priority": priorityValue,
        "Status": status,
        "assignment": assignment,
      }).catchError((error) => print(error));
  });
  }
}
