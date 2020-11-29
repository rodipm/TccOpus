import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  final Function isLoggedHandler;
  final Function isSignedUpHandler;
  final String url;

  LoginPage(this.isLoggedHandler, this.isSignedUpHandler, this.url);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginEmail = TextEditingController();
  final TextEditingController loginPass = TextEditingController();
  final TextEditingController cadastroEmail = TextEditingController();
  final TextEditingController cadastroPass = TextEditingController();

  String errorString;

  void login(String email, String pass) async {
    print(email);
    print(pass);
    var response = await http.post(widget.url + "login",
        body: json.encode({"client_email": email, "pass": pass}),
        headers: {'Content-type': 'application/json'});

    if (!widget.isLoggedHandler(json.decode(response.body))) {
      setState(() {
        this.errorString = "Email ou senha incorretos!";
      });
    }
  }

  void addClient(String email, String pass) async {
    print("addClient $email, $pass");

    var response = await http.post(widget.url + "signup",
        body: json.encode({"client_email": email, "pass": pass}),
        headers: {'Content-type': 'application/json'});

    if (widget.isSignedUpHandler(json.decode(response.body)) == false) {
      setState(() {
        this.errorString = "Email já cadastrado!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mainColumnWidgets = [
      Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.02, 10, 0, 0),
          child: Text(
            "Editor Visual - 2020",
            style: TextStyle(
                fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 70),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          
                          controller: loginEmail,
                          obscureText: false,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade700,
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          controller: loginPass,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade700,
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Senha",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Color(0xff01A0C7),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                this.login(loginEmail.text, loginPass.text);
                              },
                              child: Text(
                                "Entrar",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.white,
                  thickness: 5,
                  indent: 45,
                  endIndent: 45,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 70),
                        child: Text(
                          "Cadastro",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          controller: cadastroEmail,
                          obscureText: false,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade700,
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          controller: cadastroPass,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade700,
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Senha",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Color(0xff01A0C7),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                this.addClient(
                                    cadastroEmail.text, cadastroPass.text);
                              },
                              child: Text(
                                "Cadastrar",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    if (errorString != null)
      mainColumnWidgets.add(
        Container(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.45,
              child: Text(
                this.errorString,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 3),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade800,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: mainColumnWidgets,
          ),
        ),
      ),
    );
  }
}
