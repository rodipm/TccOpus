import 'package:flutter/material.dart';

class PollingConsumer {
  final String type = "PollingConsumer";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {
    "uri": null,
  };

  // final Offset position;
  PollingConsumer(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/PollingConsumer.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget icon(Function insertNewEipItem) {
    return SizedBox(
      width: 100,
      child: Draggable(
          feedback: componentWidget,
          onDraggableCanceled: (velocity, offset) {
            insertNewEipItem(this, offset);
          },
          child: componentWidget),
    );
  }
}
