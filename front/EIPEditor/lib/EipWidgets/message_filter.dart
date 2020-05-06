import 'package:flutter/material.dart';

class MessageFilter {
  final String type = "MessageFilter";

  final double width;
  final double height;

  Widget childContent;
  Map<String, String> childDetails = {
    "uri": null,
  };

  // final Offset position;
  MessageFilter(this.width, this.height) {
    childContent = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/MessageFilter.png'),
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
