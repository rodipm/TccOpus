import 'package:flutter/material.dart';

class CreateNewProjectPane extends StatefulWidget {
  final Function updateProjectInfoHandler;
  final double canvasPaneHeight;
  final double mainCanvasSize;
  final String clientEmail;

  CreateNewProjectPane(this.updateProjectInfoHandler, this.canvasPaneHeight,
      this.mainCanvasSize, this.clientEmail);

  @override
  _CreateNewProjectPaneState createState() => _CreateNewProjectPaneState();
}

class _CreateNewProjectPaneState extends State<CreateNewProjectPane> {
  final projectNameController = TextEditingController();
  String projectType = "EIP";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Criar Projeto"),
      content: Container(
        height: 0.5 * widget.canvasPaneHeight,
        width: 0.3 * widget.mainCanvasSize,
        child: Column(
          children: [
            Text("Nome do Projeto"),
            TextFormField(controller: projectNameController),
            Text("Tipo de Projeto"),
            DropdownButton<String>(
              value: projectType,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Color(0xff01A0C7)),
              underline: Container(
                height: 2,
                color: Color(0xff01A0C7),
              ),
              onChanged: (String newValue) {
                setState(() {
                  projectType = newValue;
                });
              },
              items: <String>['EIP', 'KALEI']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ),
      actions: <Widget>[
        // define os botões na base do dialogo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                widget.updateProjectInfoHandler(widget.clientEmail,
                    projectNameController.text, projectType);
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
