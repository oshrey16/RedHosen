import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class AllActiveReports {
  List Actives = [];
  Map<String,dynamic> AllReports = {};
  Map<String,String> test = {};

  Map<String,String> getTest(){
    return test;
  }

  AllActiveReports(){
    getActiveReportsDb();
    //TODO
    const twentyMillis = Duration(milliseconds:1000);
    Timer(twentyMillis, () => getInfo());
    // getInfo();
  }

  /// Get active reports from firebase - realtime db
  void getActiveReportsDb() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("activeReports");
    DatabaseEvent event = await ref.once();
    Map<String, dynamic> data = Map<String, dynamic>.from(
        event.snapshot.value as Map<dynamic, dynamic>);

    data.forEach((key, value) {
      Actives.add(key);
    });
  }

  void getInfo() async {
    // print(Actives);
    CollectionReference reportsStore = FirebaseFirestore.instance.collection('Reports');
    QuerySnapshot querySnapshot = await reportsStore.get();
    Map<String,dynamic> allData = {};
    for (var report in querySnapshot.docs) {
      allData[report.id] = report.data();
    }
    // print(allData);
    for (var element in allData.entries) {
      if(Actives.contains(element.key)){
        //TODO value to location
        test[element.key] = element.value['1'];
        
      }
    }
    print(test);
    //   print(element);
    //   var f = Map<String, dynamic>.from(element as Map<String, dynamic>);
    //   AllReports.addAll(f);
      // version = f['version'];
      // uid = f['uid'];
      // location = f['location'];
      // time = f['time'];
    
  }


}
