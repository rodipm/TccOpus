// Import das classes representantes dos elementos EIP (EipWidgets)
import 'package:front/EipWidgets/import_widgets.dart';
import 'package:flutter/material.dart';

class LeftSidePane extends StatefulWidget {
  final Function insertNewEipItem;
  final Function displayCreateNewProjectPaneHandler;
  final Function displayOpenProjectPaneHandler;
  final Function displaySaveProjectPaneHandler;

  LeftSidePane(this.insertNewEipItem, this.displayCreateNewProjectPaneHandler, this.displayOpenProjectPaneHandler, this.displaySaveProjectPaneHandler);
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
        color: Colors.blueGrey,
        child: Container(
          // height: 400,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black.withAlpha(35),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: double.infinity,
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(icon: Icon(Icons.create_new_folder),color: Colors.white,onPressed: () => widget.displayCreateNewProjectPaneHandler(),tooltip: "Criar projeto",),
                          IconButton(icon: Icon(Icons.folder_open),color: Colors.white,onPressed: () => widget.displayOpenProjectPaneHandler(),tooltip: "Abrir projeto",),
                          IconButton(icon: Icon(Icons.save),color: Colors.white,onPressed: () => widget.displaySaveProjectPaneHandler(),tooltip: "Salvar projeto",),
                        ]),
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
