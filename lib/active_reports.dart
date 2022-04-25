import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:red_hosen/Reports/all_reports_class.dart';

class ActiveReports extends StatefulWidget {
  const ActiveReports({Key? key}) : super(key: key);

  @override
  State<ActiveReports> createState() => _ActiveReportsState();
}

class _ActiveReportsState extends State<ActiveReports> {
  late Future<AllActiveReports> allReports;
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition shderotGooglePlex = CameraPosition(
    target: LatLng(31.525700, 34.600000),
    zoom: 14.2,
  );

  @override
  void initState() {
    // GetReports();
    // allReports = AllActiveReports.create();
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

  Widget generateCards(String key, String value) {
    return GestureDetector(
        onTap: () => print("tapped"),
        child: Card(
            elevation: 8.0,
            child: Container(
                padding: const EdgeInsets.all(1.0),
                child: Column(children: <Widget>[
                  Text("ID: $key"),
                  Text("כתובת דיווח: $value")
                ]))));
  }

  // void GetReports() async{
  //   allReports = await AllActiveReports.create();
  // }
}
