import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/indexed_db.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
    //print(email);
    //print(pass);
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
    //print("addClient $email, $pass");

    var response = await http.post(widget.url + "signup",
        body: json.encode({"client_email": email, "pass": pass}),
        headers: {'Content-type': 'application/json'});

    if (widget.isSignedUpHandler(json.decode(response.body)) == false) {
      setState(() {
        this.errorString = "Email já cadastrado!";
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void displayInfosDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Informações Sobre o Projeto"),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, right: 30.0, left: 30.0, bottom: 50.0),
                    child: Text(
                      "Sobre o projeto",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff01A0C7),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "\t\t\tEste projeto, denomidado \"Gerador de código para JVM a partir de fluxos de integração seguindo padrões EIP\" foi desenvolvido como trabalho de conclusão do curso de Engenharia Elétrica com Ênfase em computação da Escola Politécnica da Universidade de são Paulo, com o apoio da empresa Opus Software.\n\n\t\t\tTrata-se de um editor visual e gerador de código Java para auxiliar nas tarefas de desenvolvimento e prototipação de projetos de integração de sistemas por meio dos Enterprise Integration Patterns (EIP), utilizando como base a ferramenta Apache Camel.\n\n\t\t\tAlém da utilização como ferramenta para auxiliar projetos de integração, este trabalho se propõe a possibilitar o desenvolvimento de outros tipos de projetos, gerando código para diferentes linguagens de programação.\n\n\t\t\tComo forma de demonstração das possibilidades de ampliação das funcionalidades da aplicação, disponibiliza-se a opção de desenvolvimento de programas na linguagem Kaleidoscope - de propósito geral - possibilitando a geração de linguagem intermediária para LLVM e a simulação em tempo real de sua execução.\n\n",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          // height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.15,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => {
                                      _launchURL(
                                          "https://www.opus-software.com.br/")
                                    },
                                    child: Image.asset("assets/opus.png"),
                                  ),
                                ),
                              ),
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.15,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () =>
                                        {_launchURL("https://pcs.usp.br/")},
                                    child: Image.asset('assets/pcs.jpg'),
                                  ),
                                ),
                              ),
                              Container(
                                // width: MediaQuery.of(context).size.width * 0.15,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Autor:\n',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Rodrigo Perrucci Macharelli\n\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                      TextSpan(
                                        text: 'Orientador:\n',
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      TextSpan(
                                        text:
                                            'Prof. Dr. Ricardo Luis de Azevedo da Rocha',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, right: 30.0, left: 30.0, bottom: 50.0),
                    child: Text(
                      "Guia Rápido de Utilização",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff01A0C7),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 50.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "1. Realize o Cadastro:",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff01A0C7),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.15,
                            child: Image.asset("assets/infos_cadastro.gif"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 50.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "2. Crie um Projeto:",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff01A0C7),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.15,
                            child:
                                Image.asset("assets/infos_criar_projeto.gif"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 50.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "3. Arraste e Conecte os Elementos Visuais",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff01A0C7),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.15,
                            child: Image.asset(
                                "assets/infos_elementos_visuais.gif"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 50.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "4. Configure os Elementos do Diagrama",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff01A0C7),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.15,
                            child: Image.asset(
                                "assets/infos_elementos_config.gif"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 50.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "5. Gerar Código e Obter Projeto",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff01A0C7),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.15,
                            child: Image.asset("assets/infos_gera_codigo.gif"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 50.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "6. Executar projeto Gerado",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff01A0C7),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "\n\n\t\t\tO arquivo .zip obtido pode ser descompactado e executado com o Apache Maven, utilizando o seguinte comando: \n\n",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.lightBlue),
                          child: SelectableText(
                            "mvn clean package;\nmvn exec:java -Dexec.mainClass=com.opus.LaunchApp",
                            style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, right: 30.0, left: 30.0, bottom: 50.0),
                    child: Text(
                      "\n\nMais Informações",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff01A0C7),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, right: 50.0, left: 50.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                color: Color(0xff01A0C7),
                                border: Border.all(
                                    width: 10, color: Color(0xff01A0C7)),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(8)),
                              ),
                              margin: const EdgeInsets.all(4),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => {
                                    this._launchURL(
                                        "https://github.com/rodipm/TccOpus")
                                  },
                                  child: Center(
                                    child: Text(
                                      "Página do Projeto no Github",
                                      style: TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                color: Color(0xff01A0C7),
                                border: Border.all(
                                    width: 10, color: Color(0xff01A0C7)),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(8)),
                              ),
                              margin: const EdgeInsets.all(4),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => {
                                    this._launchURL(
                                        "https://github.com/rodipm/TccOpus/blob/master/docs/Monografia.pdf")
                                  },
                                  child: Center(
                                    child: Text(
                                      "Monografia",
                                      style: TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                color: Color(0xff01A0C7),
                                border: Border.all(
                                    width: 10, color: Color(0xff01A0C7)),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(8)),
                              ),
                              margin: const EdgeInsets.all(4),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => {
                                    this._launchURL(
                                        "https://github.com/rodipm/TccOpus/blob/master/docs/Banner.pdf")
                                  },
                                  child: Center(
                                    child: Text(
                                      "Banner",
                                      style: TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                color: Color(0xff01A0C7),
                                border: Border.all(
                                    width: 10, color: Color(0xff01A0C7)),
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(8)),
                              ),
                              margin: const EdgeInsets.all(4),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => {
                                    this._launchURL(
                                        "https://github.com/rodipm/TccOpus/blob/master/docs/PressRelease.pdf")
                                  },
                                  child: Center(
                                    child: Text(
                                      "Press Release",
                                      style: TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  var _focus_login_email = FocusNode();
  var _focus_login_pw = FocusNode();
  var _focus_login = FocusNode();
  var _focus_register_email = FocusNode();
  var _focus_register_pw = FocusNode();
  var _focus_register = FocusNode();

  @override
  Widget build(BuildContext context) {
    var mainColumnWidgets = [
      Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.02, 10, 0, 0),
          child: Text(
            "Editor Visual",
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
                  child: Form(
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
                          child: TextFormField(
                            focusNode: _focus_login_email,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_focus_login_pw),
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
                          child: TextFormField(
                            focusNode: _focus_login_pw,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_focus_login),
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
                                focusNode: _focus_login,
                                minWidth: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                onPressed: () {
                                  this.login(loginEmail.text, loginPass.text);
                                },
                                child: Text(
                                  "Entrar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.white,
                  thickness: 5,
                  indent: 45,
                  endIndent: 45,
                ),
                Form(
                  child: Container(
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
                          child: TextFormField(
                            focusNode: _focus_register_email,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_focus_register_pw),
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
                          child: TextFormField(
                            focusNode: _focus_register_pw,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_focus_register),
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
                                focusNode: _focus_register,
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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

    // Infos Button
    mainColumnWidgets.add(
      Container(
        child: GestureDetector(
          onTap: () => {this.displayInfosDialog()},
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff01A0C7),
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.45,
              child: Text(
                "Informações",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 3),
                textAlign: TextAlign.center,
              ),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: mainColumnWidgets,
          ),
        ),
      ),
    );
  }
}
