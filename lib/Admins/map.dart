import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'dart:math' as math;
import 'package:red_hosen/slideBar.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<LatLng> circless = [];
  List<LatLng> circles = [
    const LatLng(31.5270776, 34.595017),
    const LatLng(31.5270776, 34.595017),
    const LatLng(31.5270776, 34.595017),
    const LatLng(31.5270776, 34.595017),
    const LatLng(31.5270776, 34.595017),
    const LatLng(31.5270776, 34.595017),
    const LatLng(31.5270776, 34.595017),
    const LatLng(31.537088314092724, 34.58189221625877),
    const LatLng(31.537088314092724, 34.58189221625877),
    const LatLng(31.537088314092724, 34.58189221625877),
    const LatLng(31.537088314092724, 34.58189221625877),
    const LatLng(31.537088314092724, 34.58189221625877),
    // 31.521045874625646, 34.608280718511544
    const LatLng(31.521045874625646, 34.608280718511544),
    const LatLng(31.521045874625646, 34.608280718511544),
    const LatLng(31.521045874625646, 34.608280718511544),
    const LatLng(31.521045874625646, 34.608280718511544),
    // 31.533241404948082, 34.596173701699044
    const LatLng(31.533241404948082, 34.596173701699044),
    const LatLng(31.533241404948082, 34.596173701699044),
    // 31.521983582295597, 34.591772174891574
    const LatLng(31.521983582295597, 34.591772174891574),
    const LatLng(31.521983582295597, 34.591772174891574),
    const LatLng(31.521983582295597, 34.591772174891574),
    const LatLng(31.521983582295597, 34.591772174891574),
    // 31.5297494338688, 34.60705774120551
    const LatLng(31.5297494338688, 34.60705774120551),
    const LatLng(31.5297494338688, 34.60705774120551),
    const LatLng(31.5297494338688, 34.60705774120551),
  ];
  final Completer<GoogleMapController> _controller = Completer();
  final Map<CircleId, double> radius = {};
  late List<Circle> sderotPoints = [];

  Set<Circle>? cirr;
  static const CameraPosition shderotGooglePlex = CameraPosition(
    target: LatLng(31.525700, 34.600000),
    zoom: 14.2,
  );

  List<Circle> nullPoint = [const Circle(circleId: CircleId("null"))];
  @override
  void initState() {
    // cirr = sderotPoints.toSet();
    getPointsFromFireStore().then((value)=>setRadius().then((value) => initPoints().then((value) => calcPoints())));
    // calcPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(title: const Text("מפת העיר"), centerTitle: true),
        body: FutureBuilder(
          builder: (context, snapshot) {
            return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: shderotGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                circles: cirr ?? nullPoint.toSet());
          },
          future: calcPoints(),
        ));
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> setRadius() async {
    for (var mark in sderotPoints) {
      radius[mark.circleId] = 0;
    }
  }
  Future<void> getPointsFromFireStore() async {
    FirebaseFirestore.instance.collection('Reports').get().then((value) {
      for (var v in value.docs){
        var point = v["points"] as GeoPoint;
        circless.add(LatLng(point.latitude, point.longitude));;
      }
      print(circless);
      // print(value.docs["points"]);
    });
  }

  Future<void> calcPoints() async {
    setRadius();
    double g;
    // SetUp Counters
    Map<CircleId, int> counters = {};
    for (var mark in sderotPoints) {
      counters[mark.circleId] = 0;
    }//ASD
    for (var i = 0; i < circless.length; i++) {
      for (var mark in sderotPoints) {
        g = calculateDistance(circless[i].latitude, circless[i].longitude,
            mark.center.latitude, mark.center.longitude);
        if (g <= 0.3) {
          int count = counters[mark.circleId]!;
          count++;
          counters[mark.circleId] = count;
          break;
        }
      }
    }

    List<int> s = [];
    for (var value in counters.values) {
      s.add(value);
    }
    final lower = s.reduce(math.min);
    final higher = s.reduce(math.max);
    final Map<CircleId, double> normalized = {};
    for (var element in counters.entries) {
      normalized[element.key] = (element.value - lower) / (higher - lower);
    }
    for (var mark in sderotPoints) {
      radius[mark.circleId] = 0;
    }
    for (var element in normalized.entries) {
      radius[element.key] = convertRange(1, 0, 300, 0, element.value);
    }
    initPoints();
    setState(() {
      cirr = sderotPoints.toSet();
    });
    return;
  }

  double convertRange(double OldMax, double OldMin, double NewMax,
      double NewMin, double OldValue) {
    var OldRange = (OldMax - OldMin);
    var NewRange = (NewMax - NewMin);
    return ((((OldValue - OldMin) * NewRange) / OldRange) + NewMin);
  }

  Future<void> initPoints() async {
    sderotPoints = [
      Circle(
        circleId: const CircleId("0"),
        consumeTapEvents: true,
        center: const LatLng(31.5270776, 34.595017),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("0")] ?? 100,
      ),
      Circle(
        circleId: const CircleId("2"),
        consumeTapEvents: true,
        center: const LatLng(31.5366064, 34.5917339),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("2")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("4"),
        consumeTapEvents: true,
        center: const LatLng(31.5192307, 34.5949097),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("4")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("6"),
        consumeTapEvents: true,
        center: const LatLng(31.5177307, 34.5885582),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("6")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("8"),
        consumeTapEvents: true,
        center: const LatLng(31.5276446, 34.5853825),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("8")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("10"),
        consumeTapEvents: true,
        center: const LatLng(31.5210233, 34.6061106),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("10")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("12"),
        consumeTapEvents: true,
        center: const LatLng(31.5234926, 34.5972915),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("12")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("14"),
        consumeTapEvents: true,
        center: const LatLng(31.5145844, 34.6001883),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("14")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("16"),
        consumeTapEvents: true,
        center: const LatLng(31.5363503, 34.5862837),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("16")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("18"),
        consumeTapEvents: true,
        center: const LatLng(31.5275714, 34.5909185),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("18")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("20"),
        consumeTapEvents: true,
        center: const LatLng(31.5145113, 34.5930643),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("20")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("22"),
        consumeTapEvents: true,
        center: const LatLng(31.5233646, 34.5873566),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("22")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("24"),
        consumeTapEvents: true,
        center: const LatLng(31.5321073, 34.58255),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("24")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("26"),
        consumeTapEvents: true,
        center: const LatLng(31.5164137, 34.6051235),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("26")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("28"),
        consumeTapEvents: true,
        center: const LatLng(31.5200355, 34.6003599),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("28")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("30"),
        consumeTapEvents: true,
        center: const LatLng(31.5323634, 34.593708),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("30")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("32"),
        consumeTapEvents: true,
        center: const LatLng(31.5321439, 34.588172),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("32")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("34"),
        consumeTapEvents: true,
        center: const LatLng(31.5222305, 34.5919914),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("34")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("36"),
        consumeTapEvents: true,
        center: const LatLng(31.5374111, 34.5817776),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("36")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("38"),
        consumeTapEvents: true,
        center: const LatLng(31.5317964, 34.5979996),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("38")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("40"),
        consumeTapEvents: true,
        center: const LatLng(31.5262362, 34.6079774),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("40")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("42"),
        consumeTapEvents: true,
        center: const LatLng(31.5249742, 34.6026559),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("42")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("44"),
        consumeTapEvents: true,
        center: const LatLng(31.5298943, 34.6055098),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("44")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("46"),
        consumeTapEvents: true,
        center: const LatLng(31.5235841, 34.6114321),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("46")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("48"),
        consumeTapEvents: true,
        center: const LatLng(31.528175, 34.600553),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("48")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("50"),
        consumeTapEvents: true,
        center: const LatLng(31.5051083, 34.6004887),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("50")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("52"),
        consumeTapEvents: true,
        center: const LatLng(31.5043033, 34.5947809),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("52")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("54"),
        consumeTapEvents: true,
        center: const LatLng(31.5092062, 34.5978279),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("54")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("56"),
        consumeTapEvents: true,
        center: const LatLng(31.5335704, 34.6033211),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("56")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("58"),
        consumeTapEvents: true,
        center: const LatLng(31.5166698, 34.6143932),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("58")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("60"),
        consumeTapEvents: true,
        center: const LatLng(31.5087671, 34.5929356),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("60")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("62"),
        consumeTapEvents: true,
        center: const LatLng(31.5327657, 34.6101446),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("62")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("64"),
        consumeTapEvents: true,
        center: const LatLng(31.5363869, 34.5970125),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("64")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("66"),
        consumeTapEvents: true,
        center: const LatLng(31.5183527, 34.5811768),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("66")] ?? 0,
      ),
      Circle(
        circleId: const CircleId("68"),
        consumeTapEvents: true,
        center: const LatLng(31.5204014, 34.5780869),
        fillColor: Colors.red.shade600.withOpacity(0.6),
        strokeColor: Colors.blue.shade600.withOpacity(0.1),
        radius: radius[const CircleId("68")] ?? 0,
      ),
    ];
  }
}
