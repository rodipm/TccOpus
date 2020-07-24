// Import das classes representantes dos elementos EIP (EipWidgets)
import 'package:front/EipWidgets/message_filter.dart';
import 'package:front/EipWidgets/message.dart';
import 'package:front/EipWidgets/content_based_router.dart';
import 'package:front/EipWidgets/message_endpoint.dart';
import 'package:front/EipWidgets/message_translator.dart';
import 'package:flutter/material.dart';

class LeftSidePane extends StatefulWidget {
  final Function insertNewEipItem;
  final Function sendDiagramHandler;

  LeftSidePane(this.insertNewEipItem, this.sendDiagramHandler);
  @override
  _LeftSidePaneState createState() => _LeftSidePaneState();
}

// Painel de seleção (lado esquerdo) dos elementos EIP arrastáveis
class _LeftSidePaneState extends State<LeftSidePane> {
  bool eipItemsMenuOpen = true;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> eipItems = {
      "MessagingSystem": [
        Message(100, 100).icon(widget.insertNewEipItem),
        MessageTranslator(100, 100).icon(widget.insertNewEipItem),
        MessageEndpoint(100, 100).icon(widget.insertNewEipItem),
      ],
      "MessageRouting": [
        ContentBasedRouter(100, 100).icon(widget.insertNewEipItem),
        MessageFilter(100, 100).icon(widget.insertNewEipItem)
      ]
    };
    return Column(
      children: <Widget>[
        Container(
          color: Colors.black.withAlpha(90),
          child: Container(
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  tooltip: "Gerar Código",
                  icon: Icon(
                    Icons.done,
                  ),
                  onPressed: () => widget.sendDiagramHandler(),
                ),
              ],
            ),
          ),
        ),
        _eipItemsMenu(eipItems),
      ],
    );
  }

  Widget _eipItemsMenu(Map<String, dynamic> eipItems) {
    return Expanded(
      child: Container(
        color: Colors.blueGrey,
        child: Container(
          // height: 400,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black.withAlpha(50),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Messaging System"),
                        ]),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: GridView.builder(
                    itemCount: eipItems["MessagingSystem"].length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 30),
                    itemBuilder: (context, index) {
                      return eipItems["MessagingSystem"][index];
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.black.withAlpha(50),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.expand_less),
                          Text("Message Routing"),
                        ]),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 100,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: GridView.builder(
                    itemCount: eipItems["MessageRouting"].length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 30),
                    itemBuilder: (context, index) {
                      return eipItems["MessageRouting"][index];
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
