import 'package:location/location.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Drive {
  double distance = 0;
  List<List<double>> waypoints = [];
  late DateTime date;
  Map drive = {};

  void map() {
    drive.addEntries([
      MapEntry("Distance", distance),
      MapEntry("Waypoints", waypoints),
      MapEntry("Date", date)
    ]);
  }
}