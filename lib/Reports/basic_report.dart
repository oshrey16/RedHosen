import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BasicReport{
  late String uid;
  late String nameReporter;
  late String phoneReporter;
  late DateTime time;
  late String location;
  late GeoPoint point;
  BasicReport(uid,time,location,point);
}

class Report extends BasicReport{
  Report(uid, time, location, point, this.fieldsTypes, this.fieldsTranslate, this.fieldsValue) : super(uid, time, location, point);
  final Map<int,dynamic> fieldsTypes;
  final Map<String,dynamic> fieldsTranslate;
  final Map<String,dynamic> fieldsValue;
}