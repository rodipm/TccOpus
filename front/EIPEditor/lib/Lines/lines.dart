import 'dart:developer';

import 'package:flutter/material.dart';

class Lines extends StatefulWidget {
  final Map<int, Map<String, dynamic>> itemsPositions;

  Lines(this.itemsPositions);

  @override
  createState() => LinesState();
}

class LinesState extends State<Lines> {
  LinesState();

  @override
  Widget build(_) => Container(
        color: Colors.grey,
        child: CustomPaint(
          size: Size.infinite,
          painter: LinesPainter(widget.itemsPositions),
        ),
      );
}

class LinesPainter extends CustomPainter {
  Map<int, Map<String, dynamic>> itemsPositions = {};

  LinesPainter(this.itemsPositions);

  @override
  void paint(Canvas canvas, Size size) {
    if (itemsPositions != null)
      itemsPositions.forEach(
        (id, value) {
          Offset _start = Offset(
              this.itemsPositions[id]["xPosition"] +
                  this.itemsPositions[id]["width"],
              this.itemsPositions[id]["yPosition"] +
                  this.itemsPositions[id]["height"] / 2);

          for (int connId in value["connectsTo"]) {
            Offset _end = Offset(
                this.itemsPositions[connId]["xPosition"],
                this.itemsPositions[connId]["yPosition"] +
                    this.itemsPositions[connId]["height"] / 2);
            if (_start == null || _end == null) return;
            // Desenho da linha e seta
            canvas.drawLine(
                _start,
                _end - Offset(15, 0),
                Paint()
                  ..strokeWidth = 4
                  ..color = Colors.black);
            canvas.drawLine(
                _end,
                _end - Offset(15, 10),
                Paint()
                  ..strokeWidth = 4
                  ..color = Colors.black);
              canvas.drawLine(
                _end,
                _end - Offset(15, -10),
                Paint()
                  ..strokeWidth = 4
                  ..color = Colors.black);
          }
        },
      );
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return true;
  }
}
