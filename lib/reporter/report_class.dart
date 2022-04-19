import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:red_hosen/mytools.dart';

class ReportClass {
  Map<String, dynamic> fields = {};
  late String version;
  // final Map<institution,bool> reportToValue;
  late Map<String, bool> reportTo = {};

  ReportClass(this.version, Map<int, TextEditingController> textControllers,
      reportToValue) {
    castControllers(textControllers);
    castReportTo(reportToValue);
    fields['version'] = version;
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
  addReport() async {
    FirebaseFirestore.instance
        .collection("Reports")
        .add(fields)
        .then((value) async {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("activeReports/" + value.id);
      await ref.set({
        "ReportTo": reportTo,
      });
    });
  }
}
