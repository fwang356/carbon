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
  final PointLatLng _end2 = const PointLatLng(33.518589, -86.810356);
  final PointLatLng _start2 = const PointLatLng(32.376541, -86.299660);
  Set<Polyline> _polylines = {};

  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates2 = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String APIKey = "AIzaSyCsRS3jv8ZAOMI4vf02R5CfZH8KWmDj9Ss";

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.748550, -84.391500),
        zoom: 4
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
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineResult result2 = await
    polylinePoints.getRouteBetweenCoordinates(
        APIKey,
        _start2,
        _end2
    );

    if (result2.points.isNotEmpty) {
      for (var point in result2.points) {
        polylineCoordinates2.add(LatLng(point.latitude, point.longitude));
      }
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: const PolylineId("poly"),
          color: MyColors.carbon,
          points: polylineCoordinates
      );


      Polyline polyline2 = Polyline(
        polylineId: const PolylineId("poly"),
        color: const Color(0xFF7badab),
        points: polylineCoordinates2
      );
      _polylines.add(polyline);
      _polylines.add(polyline2);
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
        onMapCreated: onMapCreated,
        mapType: MapType.normal
      ),
    );
  }
}