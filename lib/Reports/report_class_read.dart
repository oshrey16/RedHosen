import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:red_hosen/mytools.dart';
import 'package:red_hosen/global.dart';

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
  int numofbasic = 7;
  Map<int, dynamic> datamap = {};
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
      FirebaseDatabase.instance
          .ref("activeReports")
          .child(value.id)
          .get()
          .then((value) {
        var rt = (value.value as Map<dynamic, dynamic>);
        var reportto = rt["ReportTo"] as Map<dynamic, dynamic>;
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
        int reportLen = data.length;
        version = data['version'];
        await FirebaseFirestore.instance
            .collection("ReportTempletes")
            .doc(version)
            .get()
            .then((value) {
          reportLen = value.data()?['fields'];
        });
        for (int i = 0; i < reportLen; i++) {
          if (data[i.toString()] != null) {
            datamap[i] = data[i.toString()];
          } else {
            reportLen++;
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

  Future doneReport() async {
    await FirebaseDatabase.instance
        .ref("activeReports")
        .child(reportid)
        .get()
        .then((value) async {
      var data = (value.value as Map<dynamic, dynamic>);
      // var assignment = data["assignment"] as Map<dynamic,dynamic>;
      var status = data["Status"] as Map<dynamic, dynamic>;
      if (usertype == UserType.hosen) {
        status["hosen"] = 2;
      } else if (usertype == UserType.social) {
        status["social"] = 2;
      }
      await FirebaseDatabase.instance
          .ref("activeReports")
          .child(reportid)
          .update({"Status": status});
      doneReportInFireStore();
    });
  }

  Future doneReportInFireStore() async {
    DateTime d = DateTime.now();
    await FirebaseFirestore.instance
        .collection("Reports")
        .doc(reportid)
        .update({"doneTime": d});
  }

  Future inProgressReport() async {
    await FirebaseDatabase.instance
        .ref("activeReports")
        .child(reportid)
        .get()
        .then((value) async {
      var data = (value.value as Map<dynamic, dynamic>);
      Map<dynamic, dynamic> assignment = data["assignment"] as Map<dynamic, dynamic>;
      var status = data["Status"] as Map<dynamic, dynamic>;
      Map<String, dynamic> d = {};
      await FirebaseFirestore.instance
          .collection("Reports")
          .doc(reportid)
          .get()
          .then((value) {
        var dd = value.data()?["inProgressTime"];
        if (dd != null) {
          d = dd;
        }
      });
      if (usertype == UserType.hosen) {
        assignment["hosen"] = FirebaseAuth.instance.currentUser?.uid;
        status["hosen"] = 1;
        d["hosen"] = DateTime.now();
      } else if (usertype == UserType.social) {
        
        assignment["social"] = FirebaseAuth.instance.currentUser?.uid;
        print(assignment["social"]);
        status["social"] = 1;
        d["social"] = DateTime.now();
      }
      await FirebaseDatabase.instance
          .ref("activeReports")
          .child(reportid)
          .update({"assignment": assignment, "Status": status}).whenComplete(
              () {
        inProgressReportInFireStore(assignment, d);
      });
    });
  }

  Future inProgressReportInFireStore(assignment, d) async {
    await FirebaseFirestore.instance
        .collection("Reports")
        .doc(reportid)
        .update({"inProgressTime": d, "assignment": assignment});
  }
}
