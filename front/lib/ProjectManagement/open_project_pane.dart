import 'package:flutter/material.dart';

class OpenProjectPane extends StatefulWidget {
  final String? clientEmail;
  final List<String> projectNames;
  final Function openProjectHandler;
  final double? canvasPaneHeight;
  final double? mainCanvasSize;

  OpenProjectPane(this.clientEmail, this.projectNames, this.openProjectHandler,
      this.canvasPaneHeight, this.mainCanvasSize);

  @override
  _OpenProjectPaneState createState() => _OpenProjectPaneState();
}

class _OpenProjectPaneState extends State<OpenProjectPane> {
  String? chosenProject = "";

  @override
  Widget build(BuildContext context) {

    if (chosenProject == "")
      chosenProject = widget.projectNames[0];
      
    return AlertDialog(
      title: Text("Abrir Projeto"),
      content: Container(
        height: 0.5 * widget.canvasPaneHeight!,
        width: 0.3 * widget.mainCanvasSize!,
        child: Column(
          children: [
            Text("Nome do Projeto"),
            DropdownButton<String>(
              value: chosenProject,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              onChanged: (String? newValue) {
                //print("changed");
                setState(() {
                  chosenProject = newValue;
                });
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                widget.openProjectHandler(widget.clientEmail, chosenProject);
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
