// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'map.dart';

class TripPage extends StatefulWidget {
  const TripPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<TripPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DateTime today = DateTime.now();
    DateTime weekAgo = DateTime(today.year, today.month, today.day - 8);

    Future<QuerySnapshot<Map<String, dynamic>>> trips = firestore
        .collection("users")
        .doc(auth.currentUser.uid)
        .collection("drives")
        .where(
        'date', isGreaterThan: weekAgo)
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
              List<Padding> listItems = [];

              if(snapshot.hasData) {
                DateTime activeDate;

                for(QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.data.docs) {
                  double distance = doc.get("distance").toDouble();

                  // TODO: emissions and waypoints
                  // double emissions = doc.get("emissions");
                  // List<Map<String, dynamic>> waypoints = doc.get("waypoints");

                  DateTime dateTime = DateTime.parse(doc.get("date").toDate().toString());

                  if (activeDate == null && activeDate != dateTime) {
                    listItems.add(
                        Padding(
                            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                            child: Text(
                                DateFormat.yMMMd().format(dateTime),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700
                                )
                            )
                        )
                    );
                    activeDate = dateTime;
                  }

                  listItems.add(TripItem(distance));
                }
              }
              return ListView(
                    children: listItems
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

  Widget TripItem(double distance) {
    String distanceString = NumberFormat("###0.0##", "en_US").format(distance);

    return Padding(
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
                      child: Text("Distance: $distanceString km \n\nCarbon Emissions: :) kg")
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
    );
  }
}
