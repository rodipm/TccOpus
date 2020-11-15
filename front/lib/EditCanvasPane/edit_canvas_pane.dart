// Base widget for stackable movable item
import 'package:flutter/material.dart';

class EditCanvasPane extends StatefulWidget {
  final double editCanvasPaneHeight;
  final Function displayCreateNewProjectPaneHandler;
  final Function displayOpenProjectPaneHandler;
  final Function displaySaveProjectPaneHandler;
  final Function generateCodeHandler;
  final Function undoCanvasHandler;
  final Function redoCanvasHandler;
  final Function isProjectCreated;

  EditCanvasPane(
      this.displayCreateNewProjectPaneHandler,
      this.displayOpenProjectPaneHandler,
      this.displaySaveProjectPaneHandler,
      this.editCanvasPaneHeight,
      this.generateCodeHandler,
      this.undoCanvasHandler,
      this.redoCanvasHandler,
      this.isProjectCreated);

  @override
  _EditCanvasPaneState createState() => _EditCanvasPaneState();
}

class _EditCanvasPaneState extends State<EditCanvasPane> {
  double itemBlockWidth;

  @override
  Widget build(BuildContext context) {
    this.itemBlockWidth = MediaQuery.of(context).size.width / 3;

    return Container(
      height: widget.editCanvasPaneHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: this.itemBlockWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: widget.isProjectCreated() == true
                      ? null
                      : () => widget.displaySaveProjectPaneHandler(),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: widget.isProjectCreated() == true
                            ? Color(0xff01A0C7)
                            : Colors.grey),
                    child: Container(
                      height: widget.editCanvasPaneHeight,
                      width: this.itemBlockWidth / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.save),
                            color: Colors.white,
                            onPressed: widget.isProjectCreated() == true
                                ? () => widget.displaySaveProjectPaneHandler()
                                : null,
                            tooltip: "Salvar projeto",
                          ),
                          Text(
                            "Salvar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.displayCreateNewProjectPaneHandler(),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xff01A0C7)),
                    child: Container(
                      height: widget.editCanvasPaneHeight,
                      width: this.itemBlockWidth / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.create_new_folder),
                            color: Colors.white,
                            onPressed: () =>
                                widget.displayCreateNewProjectPaneHandler(),
                            tooltip: "Novo Projeto",
                          ),
                          Text(
                            "Novo",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.displayOpenProjectPaneHandler(),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xff01A0C7)),
                    child: Container(
                      height: widget.editCanvasPaneHeight,
                      width: this.itemBlockWidth / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.create_new_folder),
                            color: Colors.white,
                            onPressed: () =>
                                widget.displayOpenProjectPaneHandler(),
                            tooltip: "Abrir Projeto",
                          ),
                          Text(
                            "Abrir",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: this.itemBlockWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.isProjectCreated() == true
                      ? () => widget.undoCanvasHandler()
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: widget.isProjectCreated() == true
                            ? Color(0xff01A0C7)
                            : Colors.grey),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: widget.isProjectCreated() == true
                            ? Color(0xff01A0C7)
                            : Colors.grey,
                      ),
                      padding: EdgeInsets.only(right: 3),
                      child: Container(
                        height: widget.editCanvasPaneHeight,
                        width: this.itemBlockWidth / 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.undo,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.isProjectCreated() == true
                      ? () => widget.redoCanvasHandler()
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: widget.isProjectCreated() == true
                            ? Color(0xff01A0C7)
                            : Colors.grey),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: widget.isProjectCreated() == true
                            ? Color(0xff01A0C7)
                            : Colors.grey,
                      ),
                      child: Container(
                        height: widget.editCanvasPaneHeight,
                        width: this.itemBlockWidth / 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.redo,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.isProjectCreated() == true
                ? () => widget.generateCodeHandler()
                : null,
            child: Container(
              width: this.itemBlockWidth,
              padding: EdgeInsets.fromLTRB(
                  0, 0, MediaQuery.of(context).size.width * 0.02, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: widget.isProjectCreated() == true
                          ? Color(0xff01A0C7)
                          : Colors.grey,
                    ),
                    child: Container(
                      height: widget.editCanvasPaneHeight,
                      width: MediaQuery.of(context).size.width * 0.15 -
                          MediaQuery.of(context).size.width * 0.02,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          Text(
                            "Gerar Código",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
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
