import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
Set<Circle> circles = {Circle(
    circleId: const CircleId("1"),
    consumeTapEvents: true,
    onTap: ()  {print("asd!!!");},
    center: const LatLng(31.52959286958604, 34.60668357390962),
    fillColor: Colors.red.shade600.withOpacity(0.6),
    strokeColor: Colors.blue.shade600.withOpacity(0.1),
    radius: 100,
),
Circle(
    circleId: const CircleId("2"),
    center: const LatLng(31.534605703967422, 34.5881861779478),
    fillColor: Colors.red.shade600.withOpacity(0.6),
    strokeColor: Colors.red.shade600.withOpacity(0.1),
    radius: 200,
),
Circle(
    circleId: const CircleId("3"),
    center: const LatLng(31.526886929797815, 34.5953531076509),
    fillColor: Colors.red.shade600.withOpacity(0.6),
    strokeColor: Colors.blue.shade600.withOpacity(0.1),
    radius: 300,
)

};
  static const CameraPosition shderotGooglePlex = CameraPosition(
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
        mapType: MapType.normal,
        initialCameraPosition: shderotGooglePlex,
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