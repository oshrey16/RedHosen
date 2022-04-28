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


  ReportClass(this.version, Map<int, TextEditingController> textControllers,
      reportToValue, this.useruid, this.location, this.time, this.points, this.priorityValue, this.numberpeople) {
    castControllers(textControllers);
    castReportTo(reportToValue);
    fields['version'] = version;
    fields['useruid'] = useruid;
    fields['location'] = location;
    fields['time'] = DateTime.now();
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

  castReportTo(Map<institution, bool> reportToValue) {
    reportToValue.forEach((k, v) {
      reportTo[k.name] = v;
    });
  }

  /// Add Report To Firestore
  /// insert report to realtime DB with id in firestore
  Future addReport() async {
    FirebaseFirestore.instance
        .collection("Reports")
        .add(fields)
        .then((value) async {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("activeReports/" + value.id);
      await ref.set({
        "ReportTo": reportTo,
        "Priority": priorityValue,
      });
    });
  }
}
