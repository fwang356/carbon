// @dart=2.9
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'main.dart';
import 'help.dart';
import 'trips.dart';
import 'drive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  //DeviceIdentifier carID = "" as DeviceIdentifier;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Location location = Location();
  bool _tracking = false;
  String message = "Start Tracking!";

  List<Color> gradientColors = [
    const Color(0xff4d4e6d),
    const Color(0xff8f91cf),
  ];

  double calculate(double distance, double mpg, String gasType) {
    double emissions;
    if (gasType == "Gasoline") {
      emissions = 8.887;
    } else {
      emissions = 10.18;
    }
    double gallons = distance / mpg;
    return emissions * gallons;
  }

  /*
  double bluetooth() {
    flutterBlue.connectedDevices.then((value) {
      for (BluetoothDevice d in value) {
        if (d.id == carID) {
          BluetoothDevice car = d;
          bool connected = true;
          Drive drive = Drive();
          drive.date = DateTime.now();
          while (connected) {
            connected = false;
            flutterBlue.connectedDevices.then((list) {
              for (BluetoothDevice device in list) {
                if (device.id == carID) {
                  connected = true;
                }
              }
              if (connected) {
                _trackLocation();
              }
            });
          }
        }
      }
    });
    return distance;
  }
   */


  void _trackLocation() async {
    Drive drive = Drive();
    drive.date = DateTime.now();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print(r.device);
      }
    });

     // Stop scanning
    flutterBlue.stopScan();

    _tracking = !_tracking;
    if (_tracking) {
      setState(() {
        message = "Stop Tracking";
      });
    }
    else {
      setState(() {
        message = "Start Tracking!";
      });
    }
    LocationData start = await location.getLocation();
    double lat1 = start.latitude;
    double lon1 = start.longitude;
    while (_tracking) {
      drive.waypoints.add([lat1, lon1]);
      await Future.delayed(const Duration(seconds: 5));
      LocationData curr = await location.getLocation();
      double lat2 = curr.latitude;
      double lon2 = curr.longitude;
      drive.distance += _getDistance(lat1, lon1, lat2, lon2);
      lat1 = lat2;
      lon1 = lon2;
    }
  }

  double _getDistance (double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Car-Bon: Track Your Carbon Emission!")),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 24),
                      child: ElevatedButton(
                          onPressed: _trackLocation,
                          child: Text(message,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFFFFFFF)
                              )),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF7badab),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            minimumSize: const Size(120, 50),
                          ))
                  ),

                  // TODO: Line graph of past week emissions
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SizedBox(
                        width: 350,
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            backgroundColor: const Color(0xfffffffa).withOpacity(0.1),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: const Color(0xff4d4e6d),
                                  strokeWidth: 1,
                                );
                              },
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: const Color(0xff4d4e6d),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: SideTitles(showTitles: false),
                              topTitles: SideTitles(showTitles: false),
                              bottomTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 22,
                                interval: 1,
                                getTextStyles: (context, value) => const TextStyle(
                                    color: Color(0xff4d4e6d),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                getTitles: (value) {
                                  switch (value.toInt()) {
                                    case 2:
                                      return 'MAR';
                                    case 5:
                                      return 'JUN';
                                    case 8:
                                      return 'SEP';
                                  }
                                  return '';
                                },
                                margin: 8,
                              ),
                              leftTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTextStyles: (context, value) => const TextStyle(
                                  color: Color(0xff4d4e6d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                getTitles: (value) {
                                  switch (value.toInt()) {
                                    case 1:
                                      return '10k';
                                    case 3:
                                      return '30k';
                                    case 5:
                                      return '50k';
                                  }
                                  return '';
                                },
                                reservedSize: 32,
                                margin: 12,
                              ),
                            ),
                            borderData: FlBorderData(
                                show: true,
                                border: Border.all(color: const Color(0xff4d4e6d), width: 1)),
                            minX: 0,
                            maxX: 11,
                            minY: 0,
                            maxY: 6,
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(0, 3),
                                  FlSpot(2.6, 2),
                                  FlSpot(4.9, 5),
                                  FlSpot(6.8, 3.1),
                                  FlSpot(8, 4),
                                  FlSpot(9.5, 3),
                                  FlSpot(11, 4),
                                ],
                                isCurved: true,
                                colors: gradientColors,
                                barWidth: 5,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: false,
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  colors:
                                  gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),

                  const Text(
                      "Past Week's Carbon Emissions: 0.0", // TODO: Query weekly distance from Firestore.
                      style: TextStyle(
                          fontSize: 20,
                          height: 1.5)), // TODO: Change distance to past week carbon emissions

                  Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const TripPage())
                                    );
                                  }, // Open new page
                                  child: const Text("Recent Trips",
                                      style: TextStyle(
                                          fontSize: 16
                                      )),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF7badab),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)),
                                    minimumSize: const Size(80, 40),
                                  ))
                          )
                      )
                  ),

                  SizedBox(
                      height: 200,
                      width: 360,
                      child: Card(
                          elevation: 24,
                          color: const Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: ListView(
                              children: <Widget>[
                                const Padding(
                                    padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 12),
                                    child: Text(
                                        "Save Our Environment",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700
                                        )
                                    )
                                ),

                                const Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: Text(
                                      //"The average person emits about 88.46 kg of carbon dioxide per week from driving.",
                                        'According to the UN, carbon emissions must be reduced by 7.6% per year for the next decade to prevent climate change.',
                                        style: TextStyle(
                                            fontSize: 14),
                                        textAlign: TextAlign.left)
                                ),

                                ButtonBar(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const HelpPage())
                                                );
                                              },
                                              child: const Text("How to Help",
                                                  style: TextStyle(
                                                      fontSize: 14
                                                  )),
                                              style: ElevatedButton.styleFrom(
                                                primary: const Color(0xFF7badab),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(40)),
                                                minimumSize: const Size(80, 40),
                                              ))
                                      )
                                    ]
                                )
                              ]
                          )

                      )
                  )
                ],
              )),
        )

    );
  }
}

/* TODO: Citations:
https://www.un.org/en/climatechange/science/key-findings
https://www.epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle
https://www.epa.gov/transportation-air-pollution-and-climate-change/what-you-can-do-reduce-pollution-vehicles-and
https://oceanfdn.org/how-to-reduce-your-carbon-footprint-in-the-car/
*/


class Bullet extends Text {
  const Bullet(
      String data, {
        Key key,
        TextStyle style,
        TextAlign textAlign,
        TextDirection textDirection,
        Locale locale,
        bool softWrap,
        TextOverflow overflow,
        double textScaleFactor,
        int maxLines,
        String semanticsLabel,
      }) : super(
    '• $data',
    key: key,
    style: style,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaleFactor: textScaleFactor,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
  );
}
