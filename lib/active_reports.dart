import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:red_hosen/Reports/all_reports_class.dart';
import 'package:red_hosen/mytools.dart';

class ActiveReports extends StatefulWidget {
  const ActiveReports({Key? key}) : super(key: key);

  @override
  State<ActiveReports> createState() => _ActiveReportsState();
}

class _ActiveReportsState extends State<ActiveReports> {
  late Future<AllActiveReports> allReports;
  final List<Marker> _markers = <Marker>[];
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition shderotGooglePlex = CameraPosition(
    target: LatLng(31.525700, 34.600000),
    zoom: 14.2,
  );

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
                markers: Set<Marker>.of(_markers),
                initialCameraPosition: shderotGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
                builder: (context, AsyncSnapshot<AllActiveReports> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("Loading.."));
                  } else {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error'));
                    } else {
                      if (snapshot.data != null) {
                        return ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10.0),
                            children: [
                              for (var element in snapshot.data!.test.entries)
                                generateCards(element.key, element.value)
                            ]);
                      } else {
                        return const Center(child: Text("ERROR"));
                      }
                    }
                  }
                },
                future: AllActiveReports.create()),
          ),
        ]));
  }

  Widget generateCards(String key, Map<String, dynamic> value) {
    String priority = value['priority'];
    return GestureDetector(
        onTap: () {
          var point = (value['points'] as GeoPoint);
          if (_markers.isNotEmpty) _markers.removeLast();
          _markers.add(Marker(
              markerId: MarkerId(key),
              position: LatLng(point.latitude, point.longitude),
              infoWindow: InfoWindow(title: value['location'])));
          setState(() {});
        },
        child: Card(
            color: Colors.blueGrey.shade200,
            elevation: 8.0,
            child: Container(
                // color: priority == "גבוה" ? Colors.red : priority == "בינוני" ? Colors.amber : Colors.yellow  ,
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: <Widget>[
                      Text("ID: $key"),
                      Text("כתובת דיווח: " + value['location']),
                      Text("זמן דיווח: " + value['time']),
                      Text("רמת החומרה: " + priority,style: TextStyle(color: priority == "גבוה" ? Colors.red : priority == "בינוני" ? Colors.amber.shade900 : Colors.yellow,),)
                    ]),
                    const SizedBox(width: 10,),
                    Icon(
                      Icons.emergency_outlined,
                      color: priority == "גבוה" ? Colors.red : priority == "בינוני" ? Colors.amber.shade900 : Colors.yellow,
                    ),
                  ],
                ))));
  }
}
