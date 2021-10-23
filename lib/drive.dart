import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Drive {
  double distance = 0;
  List<Map<String, double>> waypoints = [];
  late DateTime date;

  Map<String, dynamic> map() {
    return {
      "distance" : distance,
      "waypoints" : waypoints,
      "date" : date,
    };
  }
}