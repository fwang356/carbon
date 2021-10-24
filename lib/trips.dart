// @dart=2.9
import 'package:carbon/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'map.dart';

class TripPage extends StatefulWidget {
  const TripPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<TripPage> {
  List<Map<dynamic, dynamic>> trips = [];

  @override
  void initState() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    firestore.collection("users").doc(auth.currentUser.uid).collection("drives").orderBy(
        'date', descending: true
    ).get()
        .then((
        QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (trips.length < 11) {
          trips.add(doc.data() as Map);
          }
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Future<QuerySnapshot<Map<String, dynamic>>> trips = firestore
        .collection("users")
        .doc(auth.currentUser.uid)
        .collection("drives")
        .get();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Car-Bon: Recent Trips"),
      ),
      body: Center(
        child: FutureBuilder(
            future: trips,
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              List<Padding> trips = [];

              if(snapshot.hasData) {
                for(QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.data.docs) {
                  double distance = (doc.get("distance") * 1000).round() / 1000.0;
                  // TODO: emissions and waypoints
                  // double emissions = doc.get("emissions");
                  // Map<String, dynamic> waypoints = doc.get("waypoints");
                  

                  trips.add(
                    Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                        child: Card(
                            elevation: 5,
                            color: const Color(0xFFFFFFFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                                      child: Text("Distance: ${distance} km \n\nCarbon Emissions: :) kg")
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 40),
                                    child: ButtonBar(
                                        alignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const MapPage())
                                                );
                                              },
                                              child: const Text("View Route",
                                                  style: TextStyle(
                                                      fontSize: 14
                                                  )),
                                              style: ElevatedButton.styleFrom(
                                                primary: const Color(0xFF7badab),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(40)),
                                                minimumSize: const Size(60, 40),
                                              )
                                          )
                                        ]
                                    ),
                                  )
                                ]
                            )
                        )
                    ),
                  );
                }
              }
              return ListView(
                    children: trips
                /*<Widget>[
                      const Padding(
                          padding: EdgeInsets.only(top: 12, left: 12, right: 12),
                          child: Text(
                              "Day 1",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700
                              )
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                          child: Card(
                              elevation: 5,
                              color: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                  children: <Widget>[
                                    const Padding(
                                        padding: EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                                        child: Text("Distance: 30 Miles \n\nCarbon Emissions: 8.8 kg")
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: ButtonBar(
                                          alignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const MapPage())
                                                  );
                                                },
                                                child: const Text("View Route",
                                                    style: TextStyle(
                                                        fontSize: 14
                                                    )),
                                                style: ElevatedButton.styleFrom(
                                                  primary: const Color(0xFF7badab),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(40)),
                                                  minimumSize: const Size(60, 40),
                                                )
                                            )
                                          ]
                                      ),
                                    )
                                  ]
                              )
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                          child: Card(
                              elevation: 5,
                              color: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                  children: <Widget>[
                                    const Padding(
                                        padding: EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                                        child: Text("Distance: 30 Miles \n\nCarbon Emissions: 8.8 kg")
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: ButtonBar(
                                          alignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const MapPage())
                                                  );
                                                },
                                                child: const Text("View Route",
                                                    style: TextStyle(
                                                        fontSize: 14
                                                    )),
                                                style: ElevatedButton.styleFrom(
                                                  primary: const Color(0xFF7badab),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(40)),
                                                  minimumSize: const Size(60, 40),
                                                )
                                            )
                                          ]
                                      ),
                                    )
                                  ]
                              )
                          )
                      ),

                      const Padding(
                          padding: EdgeInsets.only(top: 12, left: 12, right: 12),
                          child: Text(
                              "Day 2",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700
                              )
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                          child: Card(
                              elevation: 5,
                              color: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                  children: <Widget>[
                                    const Padding(
                                        padding: EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 12),
                                        child: Text("Distance: 30 Miles \n\nCarbon Emissions: 8.8 kg")
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: ButtonBar(
                                          alignment: MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const MapPage())
                                                  );
                                                },
                                                child: const Text("View Route",
                                                    style: TextStyle(
                                                        fontSize: 14
                                                    )),
                                                style: ElevatedButton.styleFrom(
                                                  primary: const Color(0xFF7badab),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(40)),
                                                  minimumSize: const Size(60, 40),
                                                )
                                            )
                                          ]
                                      ),
                                    )
                                  ]
                              )
                          )
                      ),
                    ]*/
                );
            }),
      )
    );
  }
}

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
