import 'package:flutter/material.dart';

class MoveableStackItem extends StatefulWidget {
  static int idCounter = 0;

  final String type;
  final Widget componentWidgets;
  final Map<String, dynamic> componentConfigs;
  final Map<String, dynamic> componentConfigControllers;
  final Function updateConfigs;
  final Function buildEditPane;

  final Function clickHandler;
  final Function updatePositionHandler;
  final Function editHandler;

  Offset position;
  final bool selected;

  final int id;

  set setPosition(Offset pos) {
    position = pos;
  }

  MoveableStackItem(
      this.type,
      this.clickHandler,
      this.updatePositionHandler,
      this.editHandler,
      this.componentWidgets,
      this.componentConfigs,
      this.componentConfigControllers,
      this.updateConfigs,
      this.buildEditPane,
      this.position)
      : id = MoveableStackItem.idCounter,
        selected = false;

  MoveableStackItem.update(
      {MoveableStackItem oldItem,
      bool isSelected,
      Offset newPosition,
      Map<String, dynamic> newcomponentConfigs,
      Map<String, dynamic> newcomponentConfigControllers})
      : type = oldItem.type,
        componentWidgets = oldItem.componentWidgets,
        clickHandler = oldItem.clickHandler,
        updatePositionHandler = oldItem.updatePositionHandler,
        editHandler = oldItem.editHandler,
        position = newPosition != null ? newPosition : oldItem.position,
        id = oldItem.id,
        componentConfigs = newcomponentConfigs != null
            ? newcomponentConfigs
            : oldItem.componentConfigs,
        componentConfigControllers = newcomponentConfigControllers != null
            ? newcomponentConfigControllers
            : oldItem.componentConfigControllers,
        updateConfigs = oldItem.updateConfigs,
        buildEditPane = oldItem.buildEditPane,
        selected = isSelected != null ? isSelected : oldItem.selected;

  Map<String, dynamic> toJSON() {
    return {
      "id": this.id,
      "type": this.type,
      ...this.componentConfigs,
    };
  }

  static void incrementIdCounter() {
    MoveableStackItem.idCounter++;
  }

  @override
  _MoveableStackItemState createState() => _MoveableStackItemState();
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition;
  double yPosition;
  bool selected;

  _MoveableStackItemState() {
    MoveableStackItem.incrementIdCounter();
  }

  @override
  void initState() {
    super.initState();
    this.xPosition = widget.position.dx;
    this.yPosition = widget.position.dy;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position.dy,
      left: widget.position.dx,
      child: Container(
        decoration: widget.selected
            ? BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.blue,
                ),
              )
            : null,
        child: GestureDetector(
          onTap: () => widget.clickHandler(widget.id),
          onDoubleTap: () => widget.editHandler(widget.id),
          onPanUpdate: (tapInfo) {
            setState(() {
              widget.position += Offset(tapInfo.delta.dx, tapInfo.delta.dy);
              // xPosition += tapInfo.delta.dx;
              // yPosition += tapInfo.delta.dy;
            });
            widget.updatePositionHandler(
                widget.id, widget.position.dx, widget.position.dy, false);
          },
          onPanEnd: (details) {
            widget.updatePositionHandler(widget.id, widget.position.dx, widget.position.dy, true);
          },
          child: widget.componentWidgets,
        ),
      ),
    );
  }
}
