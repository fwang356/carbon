// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Car-Bon: Recent Trips"),
      ),
      body: Center(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0
            )
          )
        ),
    );
  }
}