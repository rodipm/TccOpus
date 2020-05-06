import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:EIPEditor/EditItemPane/edit_item_pane.dart';
import 'package:EIPEditor/LeftSidePane/left_side_pane.dart';
import 'package:EIPEditor/Lines/lines.dart';
import 'package:EIPEditor/MoveableStackItem/movable_stack_item.dart';
import 'package:flutter/material.dart';

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
  // All items in canvas
  Map<int, MoveableStackItem> items = {};

  // Holds items positions and connections
  Map<int, Map<String, dynamic>> itemsPositions = {};

  // Holds items id's while connecting them
  List<int> idsToConnect = List();

  // Current item being edited
  MoveableStackItem editingItem;
  // Right edit item pane with item details
  Widget editingItemPaneWidget;

  // Main widget sizes
  double mainCanvasSize;
  double leftSidePaneSize;
  double editPaneSize;

  // Inserts a new EIP Item into the main drag & drop area
  void insertNewEipItem(dynamic item, Offset position) {
    setState(() {
      // Corrects given position's x coordinate based on left side pane size
      Offset correctedPosition =
          Offset(position.dx - leftSidePaneSize, position.dy);

      // Add new item to items list
      MoveableStackItem _newItem = MoveableStackItem(
          item.type,
          addIdToConnect,
          updateItemPosition,
          selectEditItem,
          item.childContent,
          item.childDetails,
          correctedPosition);
      items.addAll({_newItem.id: _newItem});

      // Add new item position and connections (none)
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

  // Update current item position on screen
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

  // Update current item details (EIP configs)
  void updateItemDetails(int id, Map<String, String> _newChildDetails) {
    setState(() {
      MoveableStackItem oldItem = items[id];
      items[id] = MoveableStackItem.update(
        oldItem: oldItem,
        newChildDetails: _newChildDetails,
      );
      editingItem = null;
      editingItemPaneWidget = null;
    });
  }

  // Selects an item to be displayed on righ side pane
  void selectEditItem(int id) {
    setState(() {
      editingItem = items[id];
      this.editingItemPaneWidget =
          EditItemPane(this.editingItem, this.updateItemDetails);
    });
  }

  // Toggle item's selection border
  void toggleItemSelectedBorder(int id) {
    MoveableStackItem oldItem = items[id];
    setState(() {
      items[id] = MoveableStackItem.update(
        oldItem: oldItem,
        isSelected: !oldItem.selected,
      );
    });
  }

  // Add current selected item id to idsToconnect list
  // When 2 items are selected the connection is made
  // and idsToConnect is cleared
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

  void sendDiagram() async {
    Map<String, Map<String, dynamic>> jsonItems = {};
    Map<String, Map<String, dynamic>> jsonPositions = {};

    items.forEach((key, value) {
      jsonItems.addAll({key.toString(): value.toJSON()});
    });

    // itemsPositions.addAll(
    //   {
    //     MoveableStackItem.idCounter: {
    //       "xPosition": correctedPosition.dx,
    //       "yPosition": correctedPosition.dy,
    //       "width": 100,
    //       "height": 100,
    //       "connectsTo": new Set()
    //     }
    //   },
    // );

    for (var itemPositionKey in this.itemsPositions.keys) {
      Map<String, dynamic> parsedPositionItems = {};
      for (var itemPositionItemKey in this.itemsPositions[itemPositionKey].keys) {
        if (itemPositionItemKey != "connectsTo")
          parsedPositionItems.addAll({itemPositionItemKey: this.itemsPositions[itemPositionKey][itemPositionItemKey].toString()});
        else {
          var parsedConnectsTo = new List();
          for (var connectsToItem in this.itemsPositions[itemPositionKey][itemPositionItemKey]) {
            parsedConnectsTo.add(connectsToItem.toString());
          }
          parsedPositionItems.addAll({itemPositionItemKey: parsedConnectsTo});
        }
      }
      jsonPositions.addAll({itemPositionKey.toString(): parsedPositionItems});
    }

    var diagramPayload = {
      "items": jsonItems,
      "positions": jsonPositions,
    };

    // print(json.encode(diagramPayload));
    print(diagramPayload);
    print("Sending request...");
    final url = "http://localhost:5000/send_diagram";
    try {
      // var response = await http.post(url, body: diagramPayload);
      var response = await http.post(url,
          body: json.encode(diagramPayload),
          headers: {'Content-type': 'application/json'});
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Left pane should take 15% of screen
    this.leftSidePaneSize = MediaQuery.of(context).size.width * 0.15;

    // When there are no items selected, don't show edit item pane
    if (this.editingItem == null) {
      this.mainCanvasSize = MediaQuery.of(context).size.width * 0.85;
      this.editPaneSize = 0;
    } else {
      this.mainCanvasSize = MediaQuery.of(context).size.width * 0.70;
      this.editPaneSize = MediaQuery.of(context).size.width * 0.15;
    }

    // Widgets to be displayed on main screen
    // starts with left side pane and main canvas
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

    // If an item is being edited, add the right side pane
    if (this.editingItem != null)
      scaffoldRowChildren.add(
        Container(
          width: this.editPaneSize,
          child: this.editingItemPaneWidget,
        ),
      );

    return Scaffold(
      body: Row(
        // direction: Axis.horizontal,
        children: scaffoldRowChildren,
      ),
    );
  }
}
