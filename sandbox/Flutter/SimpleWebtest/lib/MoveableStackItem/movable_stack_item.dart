import 'package:flutter/material.dart';

class MoveableStackItem extends StatefulWidget {
  final Widget childContents;
  static int idCounter = 0;
  final Function clickHandler;
  final Function updatePositionHandler;
  
  MoveableStackItem(this.clickHandler, this.updatePositionHandler, this.childContents);

  static void incrementIdCounter() {
    MoveableStackItem.idCounter++;
  }

  @override
  _MoveableStackItemState createState() => _MoveableStackItemState();
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0;
  double yPosition = 0;
  int id;

  _MoveableStackItemState() {
    this.id = MoveableStackItem.idCounter;
    MoveableStackItem.incrementIdCounter();
    print(this.id);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onTap: () => widget.clickHandler(this.id),
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
          widget.updatePositionHandler(id, xPosition, yPosition);
        },
        child: widget.childContents,
      ),
    );
  }
}