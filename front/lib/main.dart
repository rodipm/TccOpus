// Import das classes representantes dos elementos EIP (EipWidgets)
import 'dart:isolate';

import 'package:front/LoginPage/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/MainCanvas/main_canvas.dart';

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
    });
    return this.isLogged = logInfo['logged'];
  }

  void isSignedUpHandler(var signupInfo) {
    setState(() {
      this.isLogged = signupInfo['signedup'];
      this.email = signupInfo['email'];
    });
    return this.isLogged = signupInfo['signedup'];
  }

  @override
  Widget build(BuildContext context) {
    if (this.isLogged)
      this.homeWidget = MainCanvas(widget.url, this.email);
    else
      this.homeWidget =
          LoginPage(isLoggedHandler, isSignedUpHandler, widget.url);

    return MaterialApp(
      title: 'Editor Visual',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homeWidget,
    );
  }
}
