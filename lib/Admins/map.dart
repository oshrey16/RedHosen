import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
Set<Circle> circles = Set.from([Circle(
    circleId: CircleId("1"),
    center: LatLng(31.52959286958604, 34.60668357390962),
    fillColor: Colors.red.shade600.withOpacity(0.6),
    strokeColor: Colors.blue.shade600.withOpacity(0.1),
    radius: 100,
),
Circle(
    circleId: CircleId("2"),
    center: LatLng(31.534605703967422, 34.5881861779478),
    fillColor: Colors.red.shade600.withOpacity(0.6),
    strokeColor: Colors.red.shade600.withOpacity(0.1),
    radius: 200,
),
Circle(
    circleId: CircleId("3"),
    center: LatLng(31.526886929797815, 34.5953531076509),
    fillColor: Colors.red.shade600.withOpacity(0.6),
    strokeColor: Colors.blue.shade600.withOpacity(0.1),
    radius: 300,
)

]);
  static final CameraPosition _ShderotGooglePlex = CameraPosition(
    target: LatLng(31.525700, 34.600000),
    zoom: 14.2,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("מפת העיר"),
          centerTitle: true,
        ),
        body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: _ShderotGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        circles: circles,
      ),
    );
  }

  Future<void> _test() async{
    print("ASD");
  }
}