import 'package:front/EipWidgets/import_widgets.dart';
import 'package:front/KaleiWidgets/import_widgets.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:front/ProjectManagement/create_new_project_pane.dart';
import 'package:front/ProjectManagement/open_project_pane.dart';
import 'package:front/ProjectManagement/save_project_pane.dart';
import 'package:http/http.dart' as http;
import 'package:front/EditItemPane/edit_item_pane.dart';
import 'package:front/LeftSidePane/left_side_pane.dart';
import 'package:front/EditCanvasPane/edit_canvas_pane.dart';
import 'package:front/Lines/lines.dart';
import 'package:front/MoveableStackItem/movable_stack_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html' as html;

class MainCanvas extends StatefulWidget {
  final url;
  final String clientEmail;
  final Function logoutHandler;
  MainCanvas(this.url, this.clientEmail, this.logoutHandler);
  @override
  _MainCanvasState createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  //******************//
  //  STATE VARIABLES //
  //******************//

  // Todos os itens do canvas (área editável do diagrama)
  Map<int, MoveableStackItem> items = {};

  // Posições dos itens instanciados e suas conexões
  Map<int, Map<String, dynamic>> itemsPositions = {};

  // Utilizado durante o processo de ligação entre elementos
  // Contém os ids dos componentes a serem conectados
  List<int> idsToConnect = List();

  // Item atual sendo configurado ou editado
  MoveableStackItem editingItem;

  // Elemenos EIP e Linhas no canvas
  List<Widget> canvasChild = [];

  // Stack de acoes efetuadas no canvas
  List<Map<String, dynamic>> undoStack = [];

  // Stack de acoes para serem refeitas no canvas
  List<Map<String, dynamic>> redoStack = [];

  // Utilizado para mostrar e esconder o painel de edição de items da parte direita
  Widget editingItemPaneWidget;

  // Tamanhos do widget principal contendo
  // o painel de seleção de elementos
  // canvas
  // painel de edição
  double mainCanvasSize;
  double leftSidePaneSize;
  double editPaneSize;
  double editCanvasPaneHeight;
  double canvasPaneHeight;
  double headerHeight;

  // Project info
  Map<String, dynamic> projectInfo = {
    "client": "",
    "project_name": "",
    "type": "EIP"
  };

  bool isProjectCreated = false;
  //***************************//
  //  CREATE/OPEN/SAVE PROJECT //
  //***************************//

  void displayCreateNewProjectPane() {
    print("displayCreateNewProjectPane");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return CreateNewProjectPane(this.updateProjectInfo,
            this.canvasPaneHeight, this.mainCanvasSize, widget.clientEmail);
      },
    );
    resetCanvasState();
  }

  void displayOpenProjectPane() async {
    try {
      var response = await http
          .get(widget.url + "projects?client_email=" + widget.clientEmail);
      List<String> projectNames =
          List<String>.from(json.decode(response.body)["project_names"]);

      if (projectNames.length > 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // retorna um objeto do tipo Dialog
            return OpenProjectPane(widget.clientEmail, projectNames,
                openProject, canvasPaneHeight, mainCanvasSize);
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void openProject(String clientEmail, String projectName) async {
    print("displayOpenProjectPane");
    try {
      var response = await http.post(widget.url + "open_project",
          body: json.encode({
            "client_email": clientEmail,
            "project_name": projectName,
          }),
          headers: {'Content-type': 'application/json'});
      resetCanvasState();

      print("RESPONSE");
      var responseDecoded = json.decode(response.body);
      print(responseDecoded);

      updateProjectInfo(
          responseDecoded["client"], responseDecoded["project_name"],
          responseDecoded["type"]);

      var canvasState = responseDecoded["canvas_state"];

      this.idsToConnect = [];

      for (String itemId in canvasState["items"].keys) {
        var currItem = canvasState["items"][itemId];
        print("CUR ITEM:");
        print(currItem);

        String itemType = currItem["type"];

        Offset position = Offset(
            double.parse(canvasState["itemsPositions"][itemId]["xPosition"]),
            double.parse(canvasState["itemsPositions"][itemId]["yPosition"]));

        var itemClass;

        if (this.projectInfo["type"] == "EIP")
          itemClass = eipWidgets[itemType]();
        else if (this.projectInfo["type"] == "KALEI")
          itemClass = kaleiWidgets[itemType]();

        Map<String, dynamic> parsedComponentConfigs =
            itemClass.parseComponentConfigsFromJson(currItem);

        MoveableStackItem _newItem = MoveableStackItem(
            itemType,
            addIdToConnect,
            updateItemPosition,
            selectEditItem,
            itemClass.componentWidget,
            parsedComponentConfigs,
            Map<String, dynamic>.from(itemClass.componentConfigControllers),
            itemClass.updateConfigs,
            itemClass.buildEditPane,
            position);

        print("OPEN PROJECT NEW ITEM");
        print(itemClass.componentConfigs);
        print(_newItem.componentConfigs);
        print(_newItem.componentConfigControllers);
        var consTo = Set<int>();
        for (String id in canvasState["itemsPositions"][itemId]["connectsTo"])
          consTo.add(int.parse(id));

        setState(() {
          this.isProjectCreated = true;
          this.items.addAll({int.parse(itemId): _newItem});
          this.itemsPositions.addAll({
            int.parse(itemId): {
              "xPosition": position.dx,
              "yPosition": position.dy,
              "width":
                  double.parse(canvasState["itemsPositions"][itemId]["width"]),
              "height":
                  double.parse(canvasState["itemsPositions"][itemId]["height"]),
              "connectsTo": consTo,
            }
          });
        });
      }

      updateCanvasStacks();
      updateCanvasChild();
    } catch (e) {
      print(e);
    }
  }

  void displaySaveProjectPane() {
    print("displaySaveProjectPane");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return SaveProjectPane(
            this.saveProject, this.canvasPaneHeight, this.mainCanvasSize);
      },
    );
  }

  void updateProjectInfo(client, projectName, projectType) {
    print("update project info");
    print(projectType);

    setState(() {
      this.projectInfo = {
        "client": client,
        "project_name": projectName,
        "type": projectType
      };
      this.isProjectCreated = true;
    });
  }

  void saveProject() async {
    Map<String, Map<String, dynamic>> jsonItems = {};
    Map<String, Map<String, dynamic>> jsonPositions = {};

    items.forEach((key, value) {
      jsonItems.addAll({key.toString(): value.toJSON()});
    });

    for (var itemPositionKey in this.itemsPositions.keys) {
      Map<String, dynamic> parsedPositionItems = {};
      for (var itemPositionItemKey
          in this.itemsPositions[itemPositionKey].keys) {
        if (itemPositionItemKey != "connectsTo")
          parsedPositionItems.addAll({
            itemPositionItemKey: this
                .itemsPositions[itemPositionKey][itemPositionItemKey]
                .toString()
          });
        else {
          var parsedConnectsTo = new List();
          for (var connectsToItem in this.itemsPositions[itemPositionKey]
              [itemPositionItemKey]) {
            parsedConnectsTo.add(connectsToItem.toString());
          }
          parsedPositionItems.addAll({itemPositionItemKey: parsedConnectsTo});
        }
      }
      jsonPositions.addAll({itemPositionKey.toString(): parsedPositionItems});
    }

    Map<String, dynamic> projectData = {
      "client_email": widget.clientEmail,
      "project_name": projectInfo["project_name"],
      "type": projectInfo["type"],
      "canvas_state": {
        "items": jsonItems,
        "itemsPositions": jsonPositions,
      },
    };

    try {
      await http.post(widget.url + "save_project",
          body: json.encode(projectData),
          headers: {'Content-type': 'application/json'});
      displaySaveProjectPane();
    } catch (e) {
      print(e);
    }
  }

  //*************************//
  //  CANVAS AND COMPONENTS  //
  //*************************//

  // Insere novo elemento visual na área de canvas editável
  void insertNewItem(dynamic item, Offset position) {
    setState(() {
      // Correção da coordenada x da posição do elemento
      // baseado no tamanho do painel de seleção esquerdo
      Offset correctedPosition = Offset(position.dx - leftSidePaneSize,
          position.dy - editCanvasPaneHeight - headerHeight);

      // Novo item a ser adicionado no canvas
      MoveableStackItem _newItem = MoveableStackItem(
          item.type,
          addIdToConnect,
          updateItemPosition,
          selectEditItem,
          item.componentWidget,
          Map<String, dynamic>.from(item.componentConfigs),
          Map<String, dynamic>.from(item.componentConfigControllers),
          item.updateConfigs,
          item.buildEditPane,
          correctedPosition);
      items.addAll({_newItem.id: _newItem});

      // Adiciona o item aos itensPositions
      itemsPositions.addAll(
        {
          MoveableStackItem.idCounter: {
            "xPosition": correctedPosition.dx,
            "yPosition": correctedPosition.dy,
            "width": 100,
            "height": 100,
            "connectsTo": new Set()
          }
        },
      );
      updateCanvasStacks();
      updateCanvasChild();
    });
  }

  // Remove um elemento do canvas
  void deleteItem(int itemId) {
    setState(() {
      this.items.remove(itemId);
      print(this.items);
      this.itemsPositions.remove(itemId);
      if (this.idsToConnect.contains(itemId)) this.idsToConnect = [];
      if (this.editingItem != null && this.editingItem.id == itemId)
        this.editingItem = null;

      // Remover todas as conexoes para este id
      for (int id in itemsPositions.keys) {
        itemsPositions[id]["connectsTo"].remove(itemId);
      }
    });
    updateCanvasStacks();
    updateCanvasChild();
  }

  // Atualiza a posição do item na tela
  void updateItemPosition(
      int id, double xPosition, double yPosition, bool doUpdateCanvasStack) {
    print("updateItemPosition");
    print(id);
    setState(() {
      this.itemsPositions.update(
            id,
            (item) => {
              "xPosition": xPosition,
              "yPosition": yPosition,
              "width": item["width"],
              "height": item["height"],
              "connectsTo": Set.from(item["connectsTo"])
            },
          );
    });
    if (doUpdateCanvasStack) {
      print("onPanEnd");
      updateCanvasStacks();
    }
    updateCanvasChild();
  }

  // Atualiza as configurações atuais do elemento EIP
  void updateItemDetails(int id, Map<String, dynamic> _newcomponentConfigs,
      Map<String, dynamic> _newcomponentConfigControllers) {
    setState(() {
      MoveableStackItem oldItem = items[id];
      print(oldItem.componentConfigs);
      items[id] = MoveableStackItem.update(
        oldItem: oldItem,
        newcomponentConfigs: Map<String, dynamic>.from(_newcomponentConfigs),
        newcomponentConfigControllers: _newcomponentConfigControllers,
      );
      editingItem = null;
      editingItemPaneWidget = null;
    });

    updateCanvasStacks();
  }

  // Selects an item to be displayed on righ side pane
  // Seleciona um elemento para ser mostrado e editado no
  // painel de edição
  void selectEditItem(int id) {
    setState(() {
      editingItem = items[id];
      this.editingItemPaneWidget = EditItemPane(this.editingItem, id,
          this.updateItemDetails, this.deleteItem, this.itemsPositions);
    });
    updateCanvasChild();
  }

  // Ativa e desativa a borda de indicação
  // de item selecionado
  void toggleItemSelectedBorder(int id) {
    MoveableStackItem oldItem = items[id];
    setState(() {
      items[id] = MoveableStackItem.update(
        oldItem: oldItem,
        isSelected: !oldItem.selected,
      );
    });
    updateCanvasChild();
  }

  // Adiciona um id à variável idsToConnect
  // Caso existam dois IDs efetua a conexão entre eles
  void addIdToConnect(int id) {
    setState(() {
      idsToConnect.add(id);
      // Toggle selection border on
      toggleItemSelectedBorder(id);

      if (idsToConnect.length >= 2) {
        // Toggle selection borders off
        toggleItemSelectedBorder(idsToConnect[0]);
        toggleItemSelectedBorder(idsToConnect[1]);

        // Add connection from the first selected item to the second
        if (idsToConnect[0] != idsToConnect[1]) {
          Map<int, Map<String, dynamic>> newItemsPositions = {};

          for (int id in itemsPositions.keys)
            newItemsPositions.addAll({
              id: {
                "xPosition": itemsPositions[id]["xPosition"],
                "yPosition": itemsPositions[id]["yPosition"],
                "width": itemsPositions[id]["width"],
                "height": itemsPositions[id]["height"],
                "connectsTo": Set.from(itemsPositions[id]["connectsTo"])
              }
            });

          newItemsPositions[idsToConnect[0]]["connectsTo"].add(idsToConnect[1]);
          itemsPositions = Map.from(newItemsPositions);
          updateCanvasStacks();
          updateCanvasChild();
        }

        // Clear idsToConnect
        idsToConnect.clear();
      }
    });
  }

  // Função utilizada para atualizar os widgets no canvas
  void updateCanvasChild() {
    setState(() {
      this.canvasChild = [Lines(itemsPositions), ...items.values.toList()];
    });
  }

  // Função chamada por diversas outras funções referentes a alterações no canvas
  void updateCanvasStacks() {
    this.undoStack.add({
      "items": Map.from(this.items),
      "itemsPositions": Map.from(this.itemsPositions),
      "idsToConnect": List.from(this.idsToConnect),
      "editingItem": this.editingItem
    });

    this.redoStack = [];

    print("undoStack");
    print(inspect(this.undoStack));
    print("redoStack");
    print(inspect(this.redoStack));
  }

  void resetCanvasState() {
    setState(() {
      this.items = Map();
      this.itemsPositions = Map();
      this.idsToConnect = List();
      this.editingItem = null;
      this.editingItemPaneWidget = null;
      this.undoStack = [];
      this.redoStack = [];
      MoveableStackItem.resetIdCounter();
    });
    updateCanvasStacks();
    updateCanvasChild();
  }

  // Função para atualizar o estado do canvas e refletir as alteracoes visualmente
  void updateCanvasState(Map<String, dynamic> canvasState) {
    setState(() {
      this.items = Map.from(canvasState["items"]);
      this.itemsPositions = Map.from(canvasState["itemsPositions"]);
      this.idsToConnect = List.from(canvasState["idsToConnect"]);
      this.editingItem = canvasState["editingItem"];
      for (int itemId in canvasState["items"].keys) {
        print(canvasState["items"][itemId].position);
        print(Offset(itemsPositions[itemId]["xPosition"],
            itemsPositions[itemId]["yPosition"]));

        this.items[itemId] = MoveableStackItem.update(
          oldItem: this.items[itemId],
          isSelected: this.items[itemId].selected,
          newPosition: Offset(itemsPositions[itemId]["xPosition"],
              itemsPositions[itemId]["yPosition"]),
        );
      }
    });
  }

  void undoCanvas() {
    if (this.undoStack.isNotEmpty) {
      Map<String, dynamic> currentCanvasState = this.undoStack.removeLast();
      this.redoStack.add(currentCanvasState);
      if (this.undoStack.isNotEmpty)
        updateCanvasState(this.undoStack.last);
      else
        updateCanvasState({
          "items": Map(),
          "itemsPositions": Map(),
          "idsToConnect": List(),
          "editingItem": null
        });
      updateCanvasChild();

      print("undoStack");
      print(inspect(this.undoStack));
      print("redoStack");
      print(inspect(this.redoStack));
    }
  }

  void redoCanvas() {
    if (this.redoStack.isNotEmpty) {
      Map<String, dynamic> prevCanvasState = this.redoStack.removeLast();
      this.undoStack.add(prevCanvasState);
      updateCanvasState(prevCanvasState);
      updateCanvasChild();

      print("undoStack");
      print(inspect(this.undoStack));
      print("redoStack");
      print(inspect(this.redoStack));
    }
  }

  //********************//
  //  CODE GENERATION   //
  //********************//

  // Envia os dados do diagrama para o back-end
  void generateCode() async {
    Map<String, Map<String, dynamic>> jsonItems = {};
    Map<String, Map<String, dynamic>> jsonPositions = {};

    items.forEach((key, value) {
      jsonItems.addAll({key.toString(): value.toJSON()});
    });

    // Processa os dados para transforma-los em json
    for (var itemPositionKey in this.itemsPositions.keys) {
      Map<String, dynamic> parsedPositionItems = {};
      for (var itemPositionItemKey
          in this.itemsPositions[itemPositionKey].keys) {
        if (itemPositionItemKey != "connectsTo")
          parsedPositionItems.addAll({
            itemPositionItemKey: this
                .itemsPositions[itemPositionKey][itemPositionItemKey]
                .toString()
          });
        else {
          var parsedConnectsTo = new List();
          for (var connectsToItem in this.itemsPositions[itemPositionKey]
              [itemPositionItemKey]) {
            parsedConnectsTo.add(connectsToItem.toString());
          }
          parsedPositionItems.addAll({itemPositionItemKey: parsedConnectsTo});
        }
      }
      jsonPositions.addAll({itemPositionKey.toString(): parsedPositionItems});
    }

    // Pacote a ser mandado contendo
    // os items do diagrama (com suas configurações e ids)
    // e as posições contendo as coordenadas, tamanho e conexões com outros elementos
    var diagramPayload = {
      "client_email": widget.clientEmail,
      "type": this.projectInfo["type"],
      "items": jsonItems,
      "positions": jsonPositions,
    };

    // Efetua o POST request para o back_end
    try {
      var response = await http.post(widget.url + "generate_code",
          body: json.encode(diagramPayload),
          headers: {'Content-type': 'application/json'});

      var decodedResponse = json.decode(response.body);
      var resultWidgets = [];
      for (var responseData in decodedResponse.keys) {
        if (responseData != "fileName") {
          if (responseData == "routes") {
            resultWidgets.add(Text(responseData, style: TextStyle(color: Colors.blue),),);
            resultWidgets.add(Text(decodedResponse[responseData].join(";\n") + "\n"));
          }
          else
          {
            resultWidgets.add(Text(responseData, style: TextStyle(color: Colors.blue),),);
            resultWidgets.add(Text(decodedResponse[responseData].join("\n") + "\n"));
          }
        }
      }
      // Mostra o diálogo com o código gerado e o botão de download do projeto (.zip)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: Text("Código Gerado"),
            content: Column(
              children: [
                ...resultWidgets,
                Row(
                  children: <Widget>[
                    Text("Download Project"),
                    IconButton(
                      icon: Icon(Icons.file_download),
                      onPressed: () {
                        // Efetua o download do arquivo do projeto identificado
                        // na resposta do request feito com os dados do diagrama
                        var fileName = json.decode(response.body)["fileName"];
                        print(fileName);
                        html.window.open(
                            widget.url + "download_project?fileName=$fileName&type=${this.projectInfo["type"]}",
                            "");
                      },
                    )
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  /* WIDGET BUILD */

  // Renderização do widget contendo
  // Painel de seleção de elementos EIP a esquerda
  // Diagrama editável no centro (canvas)
  // Painel de configuração de elementos EIP a direita
  @override
  Widget build(BuildContext context) {
    // Painel de edição ocupa 15% da tela
    this.leftSidePaneSize = MediaQuery.of(context).size.width * 0.15;
    this.editCanvasPaneHeight = MediaQuery.of(context).size.height * 0.05;
    this.headerHeight = MediaQuery.of(context).size.height * 0.1;
    this.canvasPaneHeight = MediaQuery.of(context).size.height -
        this.editCanvasPaneHeight -
        this.headerHeight;
    

    // Remover o painel de edição de itens quando não houver item selecionado
    if (this.editingItem == null) {
      this.mainCanvasSize = MediaQuery.of(context).size.width * 0.85;
      this.editPaneSize = 0;
    } else {
      this.mainCanvasSize = MediaQuery.of(context).size.width * 0.70;
      this.editPaneSize = MediaQuery.of(context).size.width * 0.15;
    }

    // Disposição dos Widgets na tela
    List<Widget> scaffoldRowChildren = [
      Container(
        width: this.leftSidePaneSize,
        color: Colors.grey.shade800,
        child: LeftSidePane(
          this.insertNewItem,
          this.projectInfo,
          () => this.isProjectCreated
        ),
      ),
      Container(
        width: this.mainCanvasSize,
        child: Column(
          children: <Widget>[
            Container(
              height: this.canvasPaneHeight,
              child: Stack(
                children: this.canvasChild,
              ),
            )
          ],
        ),
      ),
    ];

    // Se há um item sendo editado, adiciona-se o painel de edição
    if (this.editingItem != null)
      scaffoldRowChildren.add(
        Container(
          width: this.editPaneSize,
          child: this.editingItemPaneWidget,
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: this.headerHeight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.02, 10, 0, 0),
                      child: Text(
                        "Editor Visual",
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.02),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff01A0C7)),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.logout),
                              color: Colors.white,
                              onPressed: () => widget.logoutHandler(),
                              tooltip: "Logout",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              EditCanvasPane(
                  this.displayCreateNewProjectPane,
                  this.displayOpenProjectPane,
                  this.saveProject,
                  this.editCanvasPaneHeight,
                  this.generateCode,
                  this.undoCanvas,
                  this.redoCanvas,
                  () => this.isProjectCreated),
              Container(
                height: MediaQuery.of(context).size.height -
                    this.headerHeight -
                    this.editCanvasPaneHeight,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: scaffoldRowChildren,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
