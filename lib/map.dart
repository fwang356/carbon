// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'home_page.dart';
import 'main.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final PointLatLng _start = const PointLatLng(33.748550, -84.391500);
  final PointLatLng _end = const PointLatLng(32.391980, -86.151160);
  Set<Polyline> _polylines = {};

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String APIKey = "AIzaSyCsRS3jv8ZAOMI4vf02R5CfZH8KWmDj9Ss";

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.748550, -84.391500),
        zoom: 1
  );

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setPolylines();
  }

  void setPolylines() async {
    PolylineResult result = await
    polylinePoints.getRouteBetweenCoordinates(
        APIKey,
        _start,
        _end
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: MyColors.carbon,
          points: polylineCoordinates
      );
      _polylines.add(polyline);
    });
  }




    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
          title: const Text(
          "Car-Bon: Recent Trips"),
      ),
      body: GoogleMap(
        polylines: _polylines,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: onMapCreated
      ),
    );
  }
}