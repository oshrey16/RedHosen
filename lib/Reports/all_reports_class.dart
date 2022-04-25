import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class AllActiveReports {
  List actives = [];
  final Map<String, dynamic> allreports = {};
  final Map<String, Map<String, dynamic>> test = {};

  AllActiveReports._();

  static Future<AllActiveReports> create() async {
    AllActiveReports calendar = AllActiveReports._();
    await calendar.getActiveReportsDb().whenComplete(() => calendar.getInfo());
    return calendar;
  }

  /// Get active reports from firebase - realtime db
  Future getActiveReportsDb() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("activeReports");
    DatabaseEvent event = await ref.once();
    Map<String, dynamic> data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>);

    data.forEach((key, value) {
      actives.add(key);
    });
  }

  Future getInfo() async {
    CollectionReference reportsStore =
        FirebaseFirestore.instance.collection('Reports');
    QuerySnapshot querySnapshot = await reportsStore.get();
    Map<String, dynamic> allData = {};
    for (var report in querySnapshot.docs) {
      allData[report.id] = report.data();
    }
    for (var element in allData.entries) {
      if (actives.contains(element.key)) {
        test[element.key] = <String, dynamic>{};
        //TODO value to location
        test[element.key]?["location"] = element.value['location'];
        test[element.key]?["points"] = element.value['points'];
        print("OK!");
      }
    }
    print(test);
    //   print(element);
    //   var f = Map<String, dynamic>.from(element as Map<String, dynamic>);
    //   allreports.addAll(f);
    // version = f['version'];
    // uid = f['uid'];
    // location = f['location'];
    // time = f['time'];
  }
}
