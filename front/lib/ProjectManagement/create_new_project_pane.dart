import 'package:flutter/material.dart';

class CreateNewProjectPane extends StatefulWidget {
  final Function updateProjectInfoHandler;
  final double canvasPaneHeight;
  final double mainCanvasSize;

  CreateNewProjectPane(this.updateProjectInfoHandler, this.canvasPaneHeight,
      this.mainCanvasSize);

  @override
  _CreateNewProjectPaneState createState() => _CreateNewProjectPaneState();
}

class _CreateNewProjectPaneState extends State<CreateNewProjectPane> {
  final projectNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Criar Projeto"),
      content: Container(
        height: 0.5 * widget.canvasPaneHeight,
        width: 0.3 * widget.mainCanvasSize,
        child: Column(
          children: [Text("Nome do Projeto"), TextFormField(controller: projectNameController)],
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
                widget.updateProjectInfoHandler("Rodrigo", projectNameController.text);
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
