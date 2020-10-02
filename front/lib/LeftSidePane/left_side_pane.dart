// Import das classes representantes dos elementos EIP (EipWidgets)
import 'package:front/EipWidgets/import_widgets.dart';
import 'package:flutter/material.dart';

class LeftSidePane extends StatefulWidget {
  final Function insertNewEipItem;


  LeftSidePane(this.insertNewEipItem);
  @override
  _LeftSidePaneState createState() => _LeftSidePaneState();
}

// Painel de seleção (lado esquerdo) dos elementos EIP arrastáveis
class _LeftSidePaneState extends State<LeftSidePane> {
  bool eipItemsMenuOpen = true;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> eipItems = {
      "MessagingSystem": [],
      "MessageRouting": []
    };
    for (String _key in eipWidgets.keys) {
      var eipComponent = eipWidgets[_key]();
      eipItems[eipComponent.subType]
          .add(eipComponent.icon(widget.insertNewEipItem));
    }
    return Column(
      children: <Widget>[
        _eipItemsMenu(eipItems),
      ],
    );
  }

  Widget _eipItemsMenu(Map<String, dynamic> eipItems) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(10),),
        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 0, 0, 0),
        child: Container(
          // height: 400,
          child: Column(
            children: <Widget>[
              Container(
                // color: Colors.black.withAlpha(50),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Messaging System",
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  // margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                // color: Colors.black.withAlpha(50),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Message Routing",
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 100,
                  // margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
