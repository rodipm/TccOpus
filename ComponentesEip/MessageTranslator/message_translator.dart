import 'package:flutter/material.dart';

class MessageTranslator {
  final String type = "MessageTranslator";

  final double width;
  final double height;

  Widget childContent;
  Map<String, dynamic> childDetails = {
    "process": "public void process(Exchange exchange) {\n\tMessage in = exchange.getIn();\n\tin.setBody();\n}"
  };

  // final Offset position;
  MessageTranslator(this.width, this.height) {
    childContent = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/MessageTranslator.png'),
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
