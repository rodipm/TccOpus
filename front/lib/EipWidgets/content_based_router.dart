import 'package:flutter/material.dart';

class ContentBasedRouter {
  final String type = "ContentBasedRouter";

  final double width;
  final double height;

  Widget childContent;
  Map<String, dynamic> childDetails = {
    "choices": null,
  };

  // final Offset position;
  ContentBasedRouter(this.width, this.height) {
    childContent = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ContentBasedRouter.png'),
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
