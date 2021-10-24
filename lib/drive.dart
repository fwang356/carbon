import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Drive {
  double distance = 0;
  List<Map<String, double>> waypoints = [];
  late DateTime date;
  double emissions = 0;

  Map<String, dynamic> map() {
    return {
      "distance" : distance,
      "waypoints" : waypoints,
      "date" : date,
      "emission": emissions
    };
  }
}