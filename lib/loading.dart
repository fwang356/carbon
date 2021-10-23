// @dart=2.9
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'main.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Car-Bon"),
      ),
      body: const Center(
          child: CircularProgressIndicator(
            backgroundColor: MyColors.carbon,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff7badab))
          )
      ),
    );
  }
}