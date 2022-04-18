import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportClass {
  Map<String,dynamic> fields= {};
  late String version;

  ReportClass(this.version, Map<int, TextEditingController> textControllers){
   castControllers(textControllers);
   fields['version'] = version;
  }

  castControllers(Map<int, TextEditingController> textControllers){
      textControllers.forEach((k,v) {
        fields[k.toString()] = v.text;
    });
  }

  addReport(){
    var collection = FirebaseFirestore.instance.collection("Reports").add(fields);
  }
}