import 'package:flutter/material.dart';

class MessageEndpoint {
  final String type = "MessageEndpoint";

  final double width;
  final double height;

  Widget childContent;
  Map<String, dynamic> childDetails = {
    "protocol": [
      {
        "direct": ["name"],
        "http": ["hostname", "port"],
        "ftp": ["host", "port", "filename"]
      },
      null,
      []
    ]
  };

  // final Offset position;
  MessageEndpoint(this.width, this.height) {
    childContent = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/MessageEndpoint.png'),
          fit: BoxFit.fill,
        ),
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
