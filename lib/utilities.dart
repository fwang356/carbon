import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Utilities {
  static Future<void> createAndLoginUser(String email, String password, double mpg, String fuelType) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await auth.createUserWithEmailAndPassword(email: email, password: password);

    firestore.collection("users").doc(auth.currentUser!.uid.toString()).set({
      "fuelType": fuelType,
      "mpg": mpg,
    });
  }
}