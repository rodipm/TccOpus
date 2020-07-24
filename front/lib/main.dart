import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front/EditItemPane/edit_item_pane.dart';
import 'package:front/LeftSidePane/left_side_pane.dart';
import 'package:front/Lines/lines.dart';
import 'package:front/MoveableStackItem/movable_stack_item.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Integration Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainCanvas());
  }
}

class MainCanvas extends StatefulWidget {
  MainCanvas();
  @override
  _MainCanvasState createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  // Todos os itens do canvas (área editável do diagrama)
  Map<int, MoveableStackItem> items = {};

  // Posições dos itens instanciados e suas conexões
  Map<int, Map<String, dynamic>> itemsPositions = {};

  // Utilizado durante o processo de ligação entre elementos
  // Contém os ids dos componentes a serem conectados
  List<int> idsToConnect = List();

  // Item atual sendo configurado ou editado
  MoveableStackItem editingItem;

  // Utilizado para mostrar e esconder o painel de edição de items da parte direita
  Widget editingItemPaneWidget;

  // Tamanhos do widget principal contendo
  // o painel de seleção de elementos
  // canvas
  // painel de edição
  double mainCanvasSize;
  double leftSidePaneSize;
  double editPaneSize;

  // Insere novo elemento EIP na área de canvas editável
  void insertNewEipItem(dynamic item, Offset position) {
    setState(() {
      // Correção da coordenada x da posição do elemento 
      // baseado no tamanho do painel de seleção esquerdo
      Offset correctedPosition =
          Offset(position.dx - leftSidePaneSize, position.dy);

      // Novo item a ser adicionado no canvas
      MoveableStackItem _newItem = MoveableStackItem(
          item.type,
          addIdToConnect,
          updateItemPosition,
          selectEditItem,
          item.childContent,
          item.childDetails,
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
    });
  }

  // Atualiza a posição do item na tela
  void updateItemPosition(int id, double xPosition, double yPosition) {
    setState(() {
      this.itemsPositions.update(
            id,
            (item) => {
              "xPosition": xPosition,
              "yPosition": yPosition,
              "width": item["width"],
              "height": item["height"],
              "connectsTo": item["connectsTo"]
            },
          );
    });
  }

  // Atualiza as configurações atuais do elemento EIP
  void updateItemDetails(int id, Map<String, dynamic> _newChildDetails) {
    setState(() {
      MoveableStackItem oldItem = items[id];
      print(oldItem.childDetails);
      items[id] = MoveableStackItem.update(
        oldItem: oldItem,
        newChildDetails: _newChildDetails,
      );
      editingItem = null;
      editingItemPaneWidget = null;
    });
  }

  // Selects an item to be displayed on righ side pane
  // Seleciona um elemento para ser mostrado e editado no
  // painel de edição
  void selectEditItem(int id) {
    setState(() {
      editingItem = items[id];
      this.editingItemPaneWidget = EditItemPane(
          this.editingItem, id, this.updateItemDetails, this.itemsPositions);
    });
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
        if (idsToConnect[0] != idsToConnect[1])
          itemsPositions[idsToConnect[0]]["connectsTo"].add(idsToConnect[1]);

        // Clear idsToConnect
        idsToConnect.clear();
      }
    });
  }

  // Envia os dados do diagrama para o back-end
  void sendDiagram() async {
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
      "items": jsonItems,
      "positions": jsonPositions,
    };

    // Efetua o POST request para o back_end
    final url = "http://localhost:5000/send_diagram";
    try {
      var response = await http.post(url,
          body: json.encode(diagramPayload),
          headers: {'Content-type': 'application/json'});

      // Mostra o diálogo com o código gerado e o botão de download do projeto (.zip)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: Text("Código Gerado"),
            content: Column(
              children: [
                Text(json.decode(response.body)["routes"].join(";\n") + "\n"),
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
                            "http://localhost:5000/download_project?fileName=${fileName}",
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

  // Renderização do widget contendo
  // Painel de seleção de elementos EIP a esquerda
  // Diagrama editável no centro (canvas)
  // Painel de configuração de elementos EIP a direita
  @override
  Widget build(BuildContext context) {
    // Painel de edição ocupa 15% da tela
    this.leftSidePaneSize = MediaQuery.of(context).size.width * 0.15;

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
        color: Colors.blueGrey,
        child: LeftSidePane(this.insertNewEipItem, this.sendDiagram),
      ),
      Container(
        // flex: 85,
        width: this.mainCanvasSize,
        child: Stack(
          children: [Lines(itemsPositions), ...items.values.toList()],
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
      body: Row(
        children: scaffoldRowChildren,
      ),
    );
  }
}
