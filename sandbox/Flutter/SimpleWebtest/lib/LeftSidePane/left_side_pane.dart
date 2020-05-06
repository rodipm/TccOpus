import 'package:EIPEditor/EipWidgets/message_endpoint.dart';
import 'package:EIPEditor/EipWidgets/polling_consumer.dart';
import 'package:flutter/material.dart';

class LeftSidePane extends StatefulWidget {
  final Function insertNewEipItem;
  final Function sendDiagramHandler;

  LeftSidePane(this.insertNewEipItem, this.sendDiagramHandler);
  @override
  _LeftSidePaneState createState() => _LeftSidePaneState();
}

class _LeftSidePaneState extends State<LeftSidePane> {
  bool eipItemsMenuOpen = true;
  @override
  Widget build(BuildContext context) {
    List<Widget> eipItems = [
      PollingConsumer(100, 100).icon(widget.insertNewEipItem),
      MessageEndpoint(100, 100).icon(widget.insertNewEipItem),
    ];
    return Column(
      children: <Widget>[
        Container(
          color: Colors.black.withAlpha(50),
          child: Container(
            height: 50,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                IconButton(
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

  Widget _eipItemsMenu(List<Widget> eipItems) {
    if (eipItemsMenuOpen)
      return Expanded(
        child: GestureDetector(
          onTap: () {
            print("Tap");
            setState(() {
              this.eipItemsMenuOpen = false;
            });
          },
          child: Container(
            color: Colors.blueGrey,
            child: Container(
              height: 400,
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
                              Icon(Icons.expand_less),
                              Text("EIP Items"),
                            ]),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      height: 400,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: GridView.builder(
                        itemCount: eipItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 30),
                        itemBuilder: (context, index) {
                          return eipItems[index];
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    else
      return GestureDetector(
        onTap: () {
          print("Tap");
          setState(() {
            this.eipItemsMenuOpen = true;
          });
        },
        child: Container(
          color: Colors.black.withAlpha(50),
          child: Container(
            height: 50,
            width: double.infinity,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.expand_more),
                  Text("EIP Items"),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
