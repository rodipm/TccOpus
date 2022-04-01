// Import das classes representantes dos elementos EIP (EipWidgets)
import 'dart:isolate';

import 'package:front/LoginPage/login_page.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/MainCanvas/main_canvas.dart';
import 'package:front/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future main() async {
  // await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // final url = "https://tcc-opus-back.herokuapp.com/";
  final url = "http://localhost:5000/";


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? homeWidget;
  String? email;
  bool? isLogged = false;
  bool isCheckingEmail = false;

  bool? isLoggedHandler(var logInfo) {
    setState(() {
      this.isLogged = logInfo['logged'];
      this.email = logInfo['email'];
      setLocalStorage(this.email!);
    });
    return this.isLogged;
  }

  bool? isSignedUpHandler(var signupInfo) {
    setState(() {
      this.isLogged = signupInfo['signedup'];
      this.email = signupInfo['email'];
      setLocalStorage(this.email!);
    });
    return this.isLogged;
  }

  logOut() async {
    //print("logout");
    String? email = getLocalStorage();
    this.isCheckingEmail = true;
    if (email != null) {
      setState(() {
        this.isLogged = false;
      });
      var _ = await http.post(Uri.parse(widget.url + "logout") ,
          body: json.encode({"client_email": email}),
          headers: {'Content-type': 'application/json'});

      // bool resLogged = json.decode(response.body)['logged'];
    }
    this.isCheckingEmail = false;
  }

  isClientLogged() async {
    String? email = getLocalStorage();

    if (this.isCheckingEmail == false) {
      this.isCheckingEmail = true;
      //print("isClientLogged");
      //print("email:");
      //print(email);
      if (email != null) {
        var response = await http.post(Uri.parse(widget.url + "islogged"),
            body: json.encode({"client_email": email}),
            headers: {'Content-type': 'application/json'});

        bool? resLogged = json.decode(response.body)['logged'];
        this.isCheckingEmail = false;
        //print(resLogged);
        if (resLogged != this.isLogged) {
          setState(() {
            this.isLogged = resLogged;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    this.isClientLogged();

    this.homeWidget = MainCanvas(widget.url, this.email, this.logOut);

    // if (this.isLogged!)
    //   this.homeWidget = MainCanvas(widget.url, this.email, this.logOut);
    // else
    //   this.homeWidget =
    //       LoginPage(isLoggedHandler, isSignedUpHandler, widget.url);

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
