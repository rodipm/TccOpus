import 'package:flutter/material.dart';

class MoveableStackItem extends StatefulWidget {
  static int idCounter = 0;

  final String type;
  final Widget childContents;
  final Map<String, String> childDetails;

  final Function clickHandler;
  final Function updatePositionHandler;
  final Function editHandler;

  final Offset position;
  final bool selected;

  final int id;

  MoveableStackItem(this.type, this.clickHandler, this.updatePositionHandler,
      this.editHandler, this.childContents, this.childDetails, this.position)
      : id = MoveableStackItem.idCounter,
        selected = false;

  MoveableStackItem.update({MoveableStackItem oldItem, bool isSelected, Map<String, String> newChildDetails})
      : type = oldItem.type,
        childContents = oldItem.childContents,
        clickHandler = oldItem.clickHandler,
        updatePositionHandler = oldItem.updatePositionHandler,
        editHandler = oldItem.editHandler,
        position = oldItem.position,
        id = oldItem.id,
        childDetails = newChildDetails != null ? newChildDetails : oldItem.childDetails,
        selected = isSelected != null ? isSelected : oldItem.selected;

  Map<String, dynamic> toJSON() {
    return {
      "id": this.id.toString(),
      "type": this.type.toString(),
      ...this.childDetails,
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
      top: yPosition,
      left: xPosition,
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
              xPosition += tapInfo.delta.dx;
              yPosition += tapInfo.delta.dy;
            });
            widget.updatePositionHandler(widget.id, xPosition, yPosition);
          },
          child: widget.childContents,
        ),
      ),
    );
  }
}
