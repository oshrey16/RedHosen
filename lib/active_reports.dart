import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:red_hosen/all_reports_class.dart';

class ActiveReports extends StatefulWidget {
  const ActiveReports({Key? key}) : super(key: key);

  @override
  State<ActiveReports> createState() => _ActiveReportsState();
}

class _ActiveReportsState extends State<ActiveReports> {
  late AllActiveReports allReports;
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition shderotGooglePlex = CameraPosition(
    target: LatLng(31.525700, 34.600000),
    zoom: 14.2,
  );

  @override
  void initState() {
    allReports = AllActiveReports();
    // getDataFromDb();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("דיווחים פעילים"),
          centerTitle: true,
        ),
        body: Column(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: shderotGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )),
          const SizedBox(height: 10),
          Expanded(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  children: [
                    for(var element in allReports.test.entries) generateCards(element.key,element.value)
                // for (int i = 0; i < 20; i++) generateCards(),
              ])),
        ]));
  }

  Widget generateCards(String key, String value) {
    return GestureDetector (
      onTap: () => print("tapped"),
      child: Card(
        elevation: 8.0,
        child: Container(
            padding: const EdgeInsets.all(1.0),
            child: Column(children: <Widget>[Text("ID: $key"), Text("כתובת דיווח: $value")]))));
  }

  void getDataFromDb() async{
    AllActiveReports();
  }
}
