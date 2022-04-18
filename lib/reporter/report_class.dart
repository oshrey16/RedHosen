import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ReportClass {
  Map<String, dynamic> fields = {};
  late String version;

  ReportClass(this.version, Map<int, TextEditingController> textControllers) {
    castControllers(textControllers);
    fields['version'] = version;
  }

  castControllers(Map<int, TextEditingController> textControllers) {
    textControllers.forEach((k, v) {
      fields[k.toString()] = v.text;
    });
  }

  addReport() async {
    print("asd");
    var collection = FirebaseFirestore.instance.collection("Reports").add(fields);
    print(collection);
    DatabaseReference ref = FirebaseDatabase.instance.ref("activeReports");
    await ref.set({
      "name": "Johcn",
      "age": 18,
      "address": {"line1": "100 Mountain View"}
    });
    print("asd");
  }
}
