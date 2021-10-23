// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'auth.dart';
import "loading.dart";

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<MyApp> {
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // TODO: depending on user state, route to either login page or home page
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // TODO: don't print
          print(snapshot.toString());
          return LoadingPageApp("Couldn't Initialize Firebase");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseAuth auth = FirebaseAuth.instance;

          if (auth.currentUser != null) {
            return HomePage("Car-Bon: Track Your Carbon Emission!");
          } else {
            return LoginPage();
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingPageApp("Car-Bon: Track Your Carbon Emission!");
      },
    );
  }

  MaterialApp LoginPage() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
              bodyColor: const Color(0xFF4d4e6d)
          ),
          fontFamily: 'Montserrat',
          primarySwatch: MyColors.carbon,
          scaffoldBackgroundColor: const Color(0xFFFFFFFA)
      ),
      home: AuthPage(),
    );
  }

  MaterialApp HomePage(String title) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
              bodyColor: const Color(0xFF4d4e6d)
          ),
          fontFamily: 'Montserrat',
          primarySwatch: MyColors.carbon,
          scaffoldBackgroundColor: const Color(0xFFFFFFFA)
      ),
      home: MyHomePage(
        title: title,
      ),
    );
  }

  MaterialApp LoadingPageApp(String title) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: const TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
              bodyColor: const Color(0xFF4d4e6d)
          ),
          fontFamily: 'Montserrat',
          primarySwatch: MyColors.carbon,
          scaffoldBackgroundColor: const Color(0xFFFFFFFA)
      ),
      home: LoadingPage(
        title: title,
      ),
    );
  }
}

class MyColors {
  static const MaterialColor carbon = MaterialColor(0xFF4d4e6d, <int, Color> {
    50: Color(0xFF4d4e6d),
    100: Color(0xFF4d4e6d),
    200: Color(0xFF4d4e6d),
    300: Color(0xFF4d4e6d),
    400: Color(0xFF4d4e6d),
    500: Color(0xFF4d4e6d),
    600: Color(0xFF4d4e6d),
    700: Color(0xFF4d4e6d),
    800: Color(0xFF4d4e6d),
    900: Color(0xFF4d4e6d),
  });
}