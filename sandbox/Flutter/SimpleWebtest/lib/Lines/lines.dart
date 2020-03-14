import 'package:flutter/material.dart';

class Lines extends StatefulWidget {
  final List<Map<String, Offset>> connectionLines;

  Lines(this.connectionLines);

  @override
  createState() => LinesState();
}

class LinesState extends State<Lines> {
  LinesState();

  @override
  Widget build(_) => Container(
        child: CustomPaint(
          size: Size.infinite,
          painter: LinesPainter(widget.connectionLines),
        ),
      );
}

class LinesPainter extends CustomPainter {
  List<Map<String, Offset>> connectionLines;

  LinesPainter(this.connectionLines);

  @override
  void paint(Canvas canvas, Size size) {
    if (connectionLines != null)
      connectionLines.forEach((Map<String, Offset> connection) {
        if (connection["start"] == null || connection["end"] == null) return;
        canvas.drawLine(
            connection["start"],
            connection["end"],
            Paint()
              ..strokeWidth = 4
              ..color = Colors.redAccent);
      });
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return true;
    // return oldDelegate.start != start || oldDelegate.end != end;
  }
}
