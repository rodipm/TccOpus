import 'dart:developer';
import 'package:SimpleWebtest/EipWidgets/sample_eip.dart';
import 'package:SimpleWebtest/Lines/lines.dart';
import 'package:SimpleWebtest/MoveableStackItem/movable_stack_item.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainCanvas(),
    );
  }
}

class MainCanvas extends StatefulWidget {
  @override
  _MainCanvasState createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  Map<int, List<int>> connectedItems = {};
  List<int> idsToConnect = List();
  List<Map<String, Offset>> connectionLines = [];
  List<Widget> stackItems = new List();
  Map<int, Map<String, double>> itemsPositions = {};

  void updateItemPosition(int id, double xPosition, double yPosition) {
    this.itemsPositions.update(id, (_) => {"xPosition": xPosition, "yPosition": yPosition});
    print(inspect(this.itemsPositions));
  }

  void addIdToConnect(int id) {
    print("Adding ID: $id to idsToConnect");
    setState(() {
      idsToConnect.add(id);
      if (idsToConnect.length >= 2) {
        Offset _start = Offset(this.itemsPositions[idsToConnect[0]]["xPosition"], this.itemsPositions[idsToConnect[0]]["yPosition"]);
        Offset _end = Offset(this.itemsPositions[idsToConnect[1]]["xPosition"], this.itemsPositions[idsToConnect[1]]["yPosition"]);

        connectionLines.add({"start": _start, "end": _end});
        print("Adicionada connection line");
        idsToConnect.clear();
      }
    });
    print(inspect(this.idsToConnect));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            stackItems.add(SampleEIP(addIdToConnect, updateItemPosition));
            itemsPositions.addAll({MoveableStackItem.idCounter: {"xPosition": 0, "yPosition": 0}});
            print(inspect(this.itemsPositions));
          });
        },
      ),
      body: Stack(
        children: [Lines(connectionLines), ...stackItems],
      ),
    );
  }
}