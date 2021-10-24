// @dart=2.9
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
                "How to Help"),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
                    child: Card(
                      elevation: 6,
                      color: const Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Bullet(
                              "Drive Less. Bike, walk, and use public transportation when possible.",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16
                              )
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 16, left: 16, bottom: 4),
                    child: Card(
                      elevation: 6,
                      color: const Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Bullet(
                              "Drive Better. By driving efficiently, you can save money and save our environment.",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16
                              )
                          )
                      ),
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 4, right: 16, left: 16, bottom: 4),
                      child: Card(
                        elevation: 6,
                        color: const Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Bullet(
                                "Maintain Your Car. Keeping your car healthy will increase mileage and decrease emissions.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16
                                )
                            )
                        ),
                      )
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: ElevatedButton(
                          onPressed: () => launch('https://www.un.org/en/climatechange/science/key-findings'),
                          child: const Text("Learn More",
                              style: TextStyle(
                                  fontSize: 16
                              )),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF7badab),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            minimumSize: const Size(100, 50),
                          ))
                  ),
                ],
              )),
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
