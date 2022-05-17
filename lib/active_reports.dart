import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:red_hosen/Reports/all_reports_class.dart';
import 'package:red_hosen/Reports/report_read.dart';
import 'package:red_hosen/slideBar.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveReports extends StatefulWidget {
  const ActiveReports({Key? key}) : super(key: key);

  @override
  State<ActiveReports> createState() => _ActiveReportsState();
}

class _ActiveReportsState extends State<ActiveReports> {
  late Future<AllActiveReports> allReports;
  final List<Marker> _markers = <Marker>[];
  late GeoPoint _selectedPoints;
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition shderotGooglePlex = CameraPosition(
    target: LatLng(31.525700, 34.600000),
    zoom: 14.2,
  );

  Map<String, bool> visiblebuttons = {};

  @override
  void initState() {
    super.initState();
    allReports = AllActiveReports.create();
    allReports.then((value) {
      for (var i in value.actives) {
        visiblebuttons[i] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
        appBar: AppBar(
          title: const Text("דיווחים פעילים"),
          centerTitle: true
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
                    return const Center(child: Text("..טוען"));
                  } else {
                    if (snapshot.hasError) {
                      return const Center(child: Text("אין אירועים חדשים"));
                    } else {
                      if (snapshot.data != null) {
                        if(snapshot.data!.test.entries.isEmpty){
                          return const Center(child: Text('לא קיימים דיווחים חדשים'));
                        }
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
                future: allReports),
          ),
        ]));
  }

  Widget generateCards(String key, Map<String, dynamic> value) {
    String priority = value['priority'];
    return GestureDetector(
        onTap: () {
          closeAllcards();
          _selectedPoints = (value['points'] as GeoPoint);
          setState(() {
            visiblebuttons[key] = !visiblebuttons[key]!;
            if (_markers.isNotEmpty) _markers.removeLast();
            _markers.add(Marker(
                markerId: MarkerId(key),
                position:
                    LatLng(_selectedPoints.latitude, _selectedPoints.longitude),
                infoWindow: InfoWindow(title: value['location'])));
          });
          _goToPoint();
        },
        child: Card(
            color: Colors.blueGrey.shade200,
            elevation: 8.0,
            child: Container(
                padding: const EdgeInsets.all(1.0),
                child:
                    // ExpansionTile(
                    // title: Text(value['location']),
                    // children: [
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: <Widget>[
                      Text("ID: $key"),
                      Text("כתובת דיווח: " + value['location']),
                      Text("מספר נפגעים: " + value['numberpeople'].toString()),
                      Text(
                        "רמת החומרה: " + priority,
                        style: TextStyle(
                          color: priority == "גבוה"
                              ? Colors.red
                              : priority == "בינוני"
                                  ? Colors.amber.shade900
                                  : Colors.yellow,
                        ),
                      ),
                      Visibility(
                        child: Row(children: [ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => (ReportRead(reportid:key))));
                          },
                          child: const Text("פתח דוח"),
                          style: ElevatedButton.styleFrom(primary: Colors.brown.shade300),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: () {
                            navigateTo(_selectedPoints.latitude,_selectedPoints.longitude);
                          },
                          child: const Text("ניווט"),
                          style: ElevatedButton.styleFrom(primary: Colors.green.shade300),
                        ),
                        
                      ],),
                      visible: visiblebuttons[key]!,
                      )
                    ]),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.emergency_outlined,
                      color: priority == "גבוה"
                          ? Colors.red
                          : priority == "בינוני"
                              ? Colors.amber.shade900
                              : Colors.yellow,
                    ),
                  ],
                ))));
  }

  Future<void> _goToPoint() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_selectedPoints.latitude, _selectedPoints.longitude),
        zoom: 14.2)));
  }

  void closeAllcards() {
    setState(() {
      visiblebuttons.updateAll((key, value) => false);
    });
  }

static void navigateTo(double lat, double lng) async {
   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
   if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
   } else {
      throw 'Could not launch ${uri.toString()}';
   }
}
}
