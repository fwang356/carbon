// @dart=2.9
import 'package:carbon/signup.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'main.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<AuthPage> {
  FirebaseAuth auth;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Car-Bon"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  )
                )
              ),

              ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        //TODO FORGOT PASSWORD SCREEN GOES HERE
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(color: MyColors.carbon, fontSize: 14),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage())
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: MyColors.carbon, fontSize: 14),
                      ),
                    ),
                  ]
              ),

              ElevatedButton(
                      onPressed: () {
                        // TODO: Login
                        auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

                      },
                      child: const Text("Login",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFFFFFFF)
                          )),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF7badab),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        minimumSize: const Size(120, 50),
                      ))

            ]
          )
        )
      )
    );
  }
}