import 'package:flutter/material.dart';

class SampleEIP {
  final String type = "SampleEIP";

  final double width;
  final double height;

  Widget childContent;
  Map<String, dynamic> childDetails = {
    "fileName": null,
  };

  // final Offset position;
  SampleEIP(this.width, this.height) {
    childContent = Container(
      width: width,
      height: height,
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            color: Colors.blue,
          )
        ],
      ),
    );
  }

  Widget icon(Function insertNewEipItem) {
    return SizedBox(
      width: 100,
      child: Draggable(
          feedback: childContent,
          onDraggableCanceled: (velocity, offset) {
            insertNewEipItem(this, offset);
          },
          child: childContent),
    );
  }
}
