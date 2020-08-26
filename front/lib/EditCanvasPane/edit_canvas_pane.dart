// Base widget for stackable movable item
import 'package:flutter/material.dart';

class EditCanvasPane extends StatefulWidget {
  final double canvasSize;
  final double editCanvasPaneHeight;
  final Function generateCodeHandler;
  final Function undoCanvasHandler;
  final Function redoCanvasHandler;

  EditCanvasPane(
      this.canvasSize, this.editCanvasPaneHeight, this.generateCodeHandler, this.undoCanvasHandler, this.redoCanvasHandler);

  @override
  _EditCanvasPaneState createState() => _EditCanvasPaneState();
}

class _EditCanvasPaneState extends State<EditCanvasPane> {
  double itemWidth;

  @override
  Widget build(BuildContext context) {
    this.itemWidth = widget.canvasSize / 3;

    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      color: Colors.blueGrey,
      width: widget.canvasSize,
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.black.withAlpha(30),
            child: Container(
              height: widget.editCanvasPaneHeight,
              width: this.itemWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Desfazer"),
                  IconButton(
                    tooltip: "Desfazer",
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () => widget.undoCanvasHandler(),
                  ),
                ],
              ),
            ),
          ),
           Container(
            color: Colors.black.withAlpha(30),
            child: Container(
              height: widget.editCanvasPaneHeight,
              width: this.itemWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Refazer"),
                  IconButton(
                    tooltip: "Refazer",
                    icon: Icon(
                      Icons.arrow_forward,
                    ),
                    onPressed: () => widget.redoCanvasHandler(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black.withAlpha(30),
            child: Container(
              height: widget.editCanvasPaneHeight,
              width: this.itemWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Gerar Código"),
                  IconButton(
                    tooltip: "Gerar Código",
                    icon: Icon(
                      Icons.done,
                    ),
                    onPressed: () => widget.generateCodeHandler(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
