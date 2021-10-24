// @dart=2.9
import 'package:carbon/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'utilities.dart';
import 'main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  FirebaseAuth auth;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mpgController = TextEditingController();

  List<String> fuelTypes = ['Gasoline', 'Diesel'];
  String _selectedFuel;

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
                              )
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                          child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Password",
                              )
                          )
                      ),

                      const Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 12),
                          child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Re-Enter Password",
                              )
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
                          child: TextField(
                              controller: mpgController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Car's MPG",
                              )
                          )
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
                          child: DropdownButton<String>(
                            hint: const Text("Fuel Type"),
                            value: _selectedFuel,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedFuel = newValue;
                              });
                            },
                            items: fuelTypes.map((fuel) {
                              return DropdownMenuItem(
                                  child: Text(fuel),
                                  value: fuel
                              );
                            }).toList(),
                          )
                      ),

                      ElevatedButton(
                          onPressed: () async {
                            // TODO: Handle Signup errors (e.g. password too short, )
                            double mpg = double.parse(mpgController.text);

                            await Utilities.createAndLoginUser(emailController.text, passwordController.text, mpg, _selectedFuel);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyHomePage()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text("Sign Up",
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