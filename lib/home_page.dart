// @dart=2.9
import 'package:carbon/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
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
  bool _tracking = false;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  Location location = Location();
  String message = "Start Tracking!";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  double weeklySum = 0;
  List<MapEntry> data = [];
  List<double> emissions = [0,0,0,0,0,0,0];
  DateTime today;
  List<String> dates = [];
  List<FlSpot> points = [];
  String weekString;

  List<Color> gradientColors = [
    const Color(0xff4d4e6d),
    const Color(0xff8f91cf),
  ];

  @override
  void initState() {
    super.initState();
    query();
  }

  void query() async {
    today = DateTime.now();
    DateTime weekAgo = DateTime(today.year, today.month, today.day - 7);
    for (int i = 0; i < 7; i++) {
      dates.add(DateFormat("MM/dd").format(
          DateTime(today.year, today.month, today.day - i)));
    }

    QuerySnapshot q = await firestore.collection("users").doc(
        auth.currentUser.uid).collection("drives").where(
        'date', isGreaterThan: weekAgo).get();

    for (var doc in q.docs) {
      Map d = (doc.data() as Map);
      weeklySum += d["emission"];
      data.add(MapEntry(d['date'], d['emission']));
    }

    weekString = NumberFormat("###0.0##", "en_US").format(weeklySum);

    for (MapEntry entry in data) {
      int index = today.day - entry.key.toDate().day;
      emissions[index] += entry.value;
    }

    for (int i = 0; i < 7; i++) {
      points.add(FlSpot((i * 2).toDouble(), emissions[i]));
    }

    setState(() {});
  }


  double calculate(double distance, double mpg, String gasType) {
    double emissionsPerGallon;
    print(distance);
    print(mpg);
    print(gasType);
    if (gasType == "Gasoline") {
      emissionsPerGallon = 8.887;
    } else {
      emissionsPerGallon = 10.18;
    }
    double gallons = distance / (1.60834 * mpg);
    return emissionsPerGallon * gallons;
  }

  double _getDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

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

    _tracking = !_tracking;
    if (_tracking) {
      setState(() {
        message = "Stop Tracking";
      });
    } else {
      setState(() {
        message = "Start Tracking";
      });
    }
    LocationData start = await location.getLocation();
    double lat1 = start.latitude;
    double lon1 = start.longitude;
    while (_tracking) {
      drive.waypoints.add({
        "lat": lat1,
        "lon": lon1,
      });
      await Future.delayed(const Duration(seconds: 5));
      LocationData curr = await location.getLocation();
      double lat2 = curr.latitude;
      double lon2 = curr.longitude;
      drive.distance += _getDistance(lat1, lon1, lat2, lon2);
      lat1 = lat2;
      lon1 = lon2;
    }

    if(drive.waypoints.length > 10 && drive.distance > 0) {
      double mpg;
      String fuelType;

      await firestore.collection("users").doc(auth.currentUser.uid).get().then((
          DocumentSnapshot documentSnapshot) {
        Map data = documentSnapshot.data() as Map;
        fuelType = data["fuelType"];
        mpg = data["mpg"];
      });

      drive.emissions = calculate(drive.distance, mpg, fuelType);

      await firestore.collection("users").doc(auth.currentUser.uid).collection(
          "drives")
          .doc().set(drive.map());
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
        appBar: AppBar(
            title: const Text("Dashboard"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text("Logout"))
            ]),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: ElevatedButton(
                          onPressed: _trackLocation,
                          child: Text(message,
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0xFFFFFFFF))),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF7badab),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            minimumSize: const Size(120, 50),
                          ))),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Card(
                    elevation: 24,
                    color: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Text(
                              "Past Week's Carbon Emissions: $weekString kg",
                              style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5)),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 16, bottom: 16, right: 30),
                          child: SizedBox(
                              width: 320,
                              height: 200,
                              child: LineChart(
                                LineChartData(
                                  backgroundColor:
                                  const Color(0xfffffffa).withOpacity(0.1),
                                  lineTouchData: LineTouchData(
                                    touchTooltipData: LineTouchTooltipData(
                                      tooltipBgColor: const Color(0xfffffffa),
                                    ),
                                  ),
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
                                          fontSize: 12),
                                      getTitles: (value) {
                                        switch (value.toInt()) {
                                          case 12:
                                            if (dates.isEmpty) {
                                              return '';
                                            }
                                            return dates[0];
                                          case 10:
                                            if (dates.length < 2) {
                                              return '';
                                            }
                                            return dates[1];
                                          case 8:
                                            if (dates.length < 3) {
                                              return '';
                                            }
                                            return dates[2];
                                          case 6:
                                            if (dates.length < 4) {
                                              return '';
                                            }
                                            return dates[3];
                                          case 4:
                                            if (dates.length < 5) {
                                              return '';
                                            }
                                            return dates[4];
                                          case 2:
                                            if (dates.length < 6) {
                                              return '';
                                            }
                                            return dates[5];
                                          case 0:
                                            if (dates.length < 7) {
                                              return '';
                                            }
                                            return dates[6];
                                        }
                                        return '';
                                      },
                                      margin: 8,
                                    ),
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      interval: 20,
                                      getTextStyles: (context, value) => const TextStyle(
                                        color: Color(0xff4d4e6d),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      reservedSize: 28,
                                      margin: 12,
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                          color: const Color(0xff4d4e6d), width: 1)),
                                  minX: 0,
                                  maxX: 12,
                                  minY: 0,
                                  maxY: emissions.reduce(max),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: points,
                                      isCurved: false,
                                      colors: gradientColors,
                                      barWidth: 5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        colors: gradientColors
                                            .map((color) => color.withOpacity(0.3))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, bottom: 4),
                          child: Text(
                              "The average person emits about 88.46 kg of carbon dioxide per week from driving.",
                              style: TextStyle(
                                  fontSize: 15,
                                  height: 1),
                                  textAlign: TextAlign.left),
                        ),

                        Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 12),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const TripPage()));
                                        }, // Open new page
                                        child: const Text("Recent Trips",
                                            style: TextStyle(fontSize: 16)),
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color(0xFF7badab),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40)),
                                          minimumSize: const Size(80, 40),
                                        ))))),

                      ]
                    )
                  )
                ),

                SizedBox(
                    height: 200,
                    width: 360,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Card(
                          elevation: 24,
                          color: const Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: ListView(children: <Widget>[
                            const Padding(
                                padding: EdgeInsets.only(
                                    top: 20, right: 20, left: 20, bottom: 12),
                                child: Text("Save Our Environment",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700))),
                            const Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  //"The average person emits about 88.46 kg of carbon dioxide per week from driving.",
                                    'According to the UN, carbon emissions must be reduced by 7.6% per year for the next decade to prevent climate change.',
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.left)),
                            ButtonBar(children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const HelpPage()));
                                      },
                                      child: const Text("How to Help",
                                          style: TextStyle(fontSize: 14)),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xFF7badab),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(40)),
                                        minimumSize: const Size(80, 40),
                                      )))
                            ])
                          ])))
                    )

            ],
          )),
        ));
  }
}

/* TODO: Citations:
https://www.un.org/en/climatechange/science/key-findings
https://www.epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle
https://www.epa.gov/transportation-air-pollution-and-climate-change/what-you-can-do-reduce-pollution-vehicles-and
https://oceanfdn.org/how-to-reduce-your-carbon-footprint-in-the-car/
*/