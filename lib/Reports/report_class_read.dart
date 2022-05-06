import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:red_hosen/mytools.dart';

class BasicReport {
  String reportid;
  String? reporteruid;
  String? nameReporter;
  String? phoneReporter;
  DateTime? time;
  String? location;
  GeoPoint? point;
  int? numberpeople;
  Map<institution, bool> reportTo = {};
  // ===
  String version = "v1";
  final int numofbasic = 7;
  Map<int, String> datamap = {};
  Map<int, String> translate = {};

  BasicReport._(this.reportid);
  static Future<BasicReport> create(reportid) async {
    BasicReport basicreport = BasicReport._(reportid);
    await basicreport.readReport().whenComplete(() => basicreport
        .setnameReporter()
        .whenComplete(() => basicreport
            .readdata()
            .whenComplete(() => basicreport.readTranslate())));
    return basicreport;
  }
  // BasicReport(this.reportid) {
  //   readReport().then((value) => setnameReporter());
  //       print(nameReporter);
  // }

  Future setnameReporter() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable("getUser");
    await callable(<String, dynamic>{'uid': reporteruid}).then((value) async {
      nameReporter = value.data['name'];
      phoneReporter = value.data['phone'];
    });
  }

  Future readReport() async {
    await FirebaseFirestore.instance
        .collection("Reports")
        .doc(reportid)
        .get()
        .then((value) async {
      var data = value.data();
      if (data != null) {
        reporteruid = data['useruid'];
        time = (data['time'] as Timestamp).toDate();
        location = data['location'];
        point = (data['points'] as GeoPoint);
        numberpeople = data['numberpeople'];
      }
      FirebaseDatabase.instance.ref("activeReports").child(value.id).get().then((value) {
        var rt = (value.value as Map<dynamic, dynamic>);
        var reportto = rt["ReportTo"] as Map<dynamic,dynamic>;
        reportTo[institution.hosen] = reportto["hosen"];
        reportTo[institution.social] = reportto["social"];
      });
    });
    return 0;
  }

  Future readdata() async {
    await FirebaseFirestore.instance
        .collection("Reports")
        .doc(reportid)
        .get()
        .then((value) async {
      var data = value.data();
      if (data != null) {
        version = data['version'];
        int lo = data.length - numofbasic;
        for (int i = 0; i < lo; i++) {
          if (data[i.toString()] != null) {
            datamap[i] = data[i.toString()];
          } else {
            lo++;
          }
        }
      }
    });
    return 0;
  }

  Future readTranslate() async {
    await FirebaseFirestore.instance
        .collection("ReportTempletes")
        .doc(version)
        .collection("Translate")
        .doc("Translate")
        .get()
        .then((value) async {
      var data = value.data();
      if (data != null) {
        int lo = data.length;
        for (int i = 0; i < lo; i++) {
          if (data[i.toString()] != null) {
            translate[i] = data[i.toString()];
          } else {
            lo++;
          }
        }
      }
    });
    return 0;
  }
}
  // Report(uid) : super(uid) {
  //   readdata().then((value) => readTranslate());
  // }
