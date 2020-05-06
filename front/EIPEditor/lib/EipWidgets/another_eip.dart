import 'package:flutter/material.dart';

class AnotherEip {
  final String type = "AnotherEip";
  
  final double width;
  final double height;

  Widget childContent;
  Map<String, String> childDetails = {
    "url": null,
  };

  // final Offset position;
  AnotherEip(this.width, this.height) {
    childContent = Container(
      width: width,
      height: height,
      color: Colors.green,
    );
  }

  Widget icon(Function insertNewEipItem) {
    return Draggable(
      feedback: childContent,
      onDraggableCanceled: (velocity, offset) {
        //print(offset);
        //print(offset.dx);
        //print(offset.dy);
        insertNewEipItem(this, offset);
        //print(offset);
      },
      child: childContent
    );
  }
}
