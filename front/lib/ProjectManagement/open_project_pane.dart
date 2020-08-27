import 'package:flutter/material.dart';

class OpenProjectPane extends StatefulWidget {
  final String userName;
  final List<String> projectNames;
  final Function openProjectHandler;
  final double canvasPaneHeight;
  final double mainCanvasSize;

  OpenProjectPane(this.userName, this.projectNames, this.openProjectHandler, this.canvasPaneHeight,
      this.mainCanvasSize);

  @override
  _OpenProjectPaneState createState() => _OpenProjectPaneState();
}

class _OpenProjectPaneState extends State<OpenProjectPane> {
  @override
  Widget build(BuildContext context) {

    String chosenProject = widget.projectNames[0];

    return AlertDialog(
      title: Text("Abrir Projeto"),
      content: Container(
        height: 0.5 * widget.canvasPaneHeight,
        width: 0.3 * widget.mainCanvasSize,
        child: Column(
          children: [
            Text("Nome do Projeto"),
            DropdownButton<String>(
              value: widget.projectNames[0],
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              onChanged: (String newValue) {
                chosenProject = newValue;
              },
              items: widget.projectNames.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        // define os botões na base do dialogo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                widget.openProjectHandler(widget.userName, chosenProject);
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )
      ],
    );
  }
}
