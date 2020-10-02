// Import das classes representantes dos elementos EIP (EipWidgets)
import 'dart:isolate';

import 'package:front/LoginPage/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/MainCanvas/main_canvas.dart';
import 'package:front/utils.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final url = DotEnv().env['BACK_URL'];

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget homeWidget;
  String email;
  bool isLogged = false;


  bool isLoggedHandler(var logInfo) {
    setState(() {
      this.isLogged = logInfo['logged'];
      this.email = logInfo['email'];
      setLocalStorage("SAMPLE_SESSION_ID");
    });
    return this.isLogged;
  }

  void isSignedUpHandler(var signupInfo) {
    setState(() {
      this.isLogged = signupInfo['signedup'];
      this.email = signupInfo['email'];
      setLocalStorage("SAMPLE_SESSION_ID");
    });
  }

  @override
  Widget build(BuildContext context) {

    print("LOCAL STORAGE");
    String sessionId = getLocalStorage();

    if (sessionId != null)
      this.isLogged = true;
      
    if (this.isLogged)
      this.homeWidget = MainCanvas(widget.url, this.email);
    else
      this.homeWidget =
          LoginPage(isLoggedHandler, isSignedUpHandler, widget.url);

    return MaterialApp(
      title: 'Editor Visual',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: homeWidget,
    );
  }
}
